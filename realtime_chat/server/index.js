"use strict";

import { Server } from "socket.io";
import $http from "http";
import $express from "express";

// import uuid from "uuid";

import { v4 as uuidv4 } from "uuid";

const app = $express();
app.use($express.json());

import { handlers, status, emits, server } from "./constants/constants";

const users = [];
const rooms = [];

const http = $http.createServer(app);

const io = new Server(http, {
  // path: server.io.path,
});

io.on("connection", (socket) => {
  socket.on(handlers.validate, (inData, inCallback) => {
    let user = users.find((item) => item.userName == inData.userName);
    if (user) {
      if (user.password === inData.password) {
        user.socket = socket.id;
        inCallback({
          status: status.ok,
          user: user,
        });
      } else {
        inCallback({ status: status.fail });
      }
    } else {
      let newUser = {
        ...inData,
        uid: uuidv4(),
        socket: socket.id,
      };
      users.push(newUser);
      io.emit(emits.newUser, newUser);
      inCallback({
        status: status.created,
        user: newUser,
      });
    }
  });

  socket.on(handlers.create, (inData, inCallback) => {
    if (rooms.some((item) => item.title == inData.title)) {
      inCallback({ status: status.exist });
    } else {
      const user = users.find((item) => item.uid == inData.createdByUser);
      rooms.push(inData);
      user.createdRoomsId.push(inData.id);
      io.emit(emits.created, inData);
      inCallback({ status: status.created });
    }
  });

  socket.on(handlers.listRooms, (callback) => {
    callback({ status: status.ok, listRooms: rooms });
  });

  socket.on(handlers.listUsers, (callback) => {
    let filteredUsers = users.filter((item) => item.socket != null);
    socket.emit(emits.givedListUsers, {
      status: status.ok,
      listUsers: filteredUsers,
    });
  });

  socket.on(handlers.join, (inData, inCallback) => {
    try {
      let room = rooms.find((item) => item.id == inData.id);
      if (!room) {
        inCallback({ status: status.deleted });
        return;
      }
      if (room.userList.length >= rooms.maxPeople) {
        inCallback({ status: status.full });
      } else {
        let userInRoom = room.userList.find(
          (item) => item.uid == inData["user"].uid
        );
        if (typeof userInRoom == "undefined") {
          room.userList.push(inData["user"]);
        }
        socket.join(room.id);
        io.to(room.id).emit(emits.joined, { room: room, user: inData["user"] });
        io.emit(emits.userJoined, { room: room, user: inData["user"] });
        inCallback({ status: status.ok, room: room });
      }
    } catch (error) {
      inCallback({ status: status.fail });
    }
  });

  socket.on(handlers.post, (inData, inCallback) => {
    try {
      io.in(inData.room.id).emit(emits.posted, {
        status: status.ok,
        message: inData.message,
      });

      inCallback({ status: status.ok });
    } catch (error) {
      inCallback({ status: status.fail });
    }
  });

  socket.on(handlers.invite, (inData, inCallback) => {
    try {
      let room = rooms.find((item) => item.id == inData.roomId);
      room.invitedUserIdList.push(inData.user.uid);
      io.emit(emits.newInvitedUser, { room: room, user: inData.user });
      io.to(inData.user.socket).emit(emits.invited, {
        room: room,
        user: inData.user,
      });
      inCallback({ status: status.ok });
    } catch (error) {
      inCallback({ status: status.fail });
    }
  });

  socket.on(handlers.leave, (inData, inCallback) => {
    try {
      let room = rooms.find((item) => item.id == inData.room.id);
      io.to(room.id).emit(emits.left, { user: inData.user });
      io.emit(emits.userLeft, { room: room, user: inData.user });
      let userIndex = room.userList.findIndex(
        (item) => item.uid == inData.user.uid
      );
      room.userList.splice(userIndex, 1);
      inCallback({ status: status.ok });
      socket.leave(room.id);
    } catch (error) {
      inCallback({ status: status.fail });
    }
  });

  socket.on(handlers.close, (inData, inCallback) => {
    delete rooms[inData.title];
    socket.broadcast.emit(emits.closed, {
      title: inData.title,
      rooms: rooms,
    });
    inCallback(rooms);
  });

  // todo: needs to change
  socket.on(handlers.kick, (inData) => {
    try {
      io.to(inData.room.id).emit(emits.kicked, { user: inData.user });
    } catch (error) {
      inCallback({ status: status.fail });
    }
  });

  socket.on("disconnect", () => {
    let user = users.find((item) => item.socket == item.socket);
    user.socket = null;
    for (const room of rooms) {
      let userIndex = room.userList.findIndex((item) => item.uid == user.uid);
      io.to(room.id).emit(emits.left, { user: user });
      room.userList.splice(userIndex, 1);
    }
  });
});

http.listen(server.port, server.adress, (error) => {
  if (error) console.log(error);
  console.log(`${server.adress}:${server.port}${server.io.path}`);
});
