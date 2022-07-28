const server = {
  port: process.env.PORT || 3000,
  adress: process.env.adress || "127.0.0.1",

  io: {
    path: "/chat/",
  },
};

const handlers = {
  test: "test",
  connection: "connection",
  validate: "validate",
  create: "create",
  listRooms: "listRooms",
  listUsers: "listUsers",
  join: "join",
  post: "post",
  invite: "invite",
  leave: "leave",
  close: "close",
  kick: "kick",
};

const status = {
  ok: "ok",
  fail: "fail",
  created: "created",
  full: "full",
  exist: "exist",
  deleted: "deleted",
  joined: "joined",
};

const emits = {
  test: "test",
  givedListUsers: "givedListUsers",

  newUser: "newUser",
  created: "created",
  joined: "joined",
  posted: "posted",
  invited: "invited",
  left: "left",
  closed: "closed",
  kicked: "kicked",

  userJoined: "userJoined",
  userLeft: "userLeft",
  newInvitedUser: "newInvitedUser",
};

export { handlers, status, emits, server };
