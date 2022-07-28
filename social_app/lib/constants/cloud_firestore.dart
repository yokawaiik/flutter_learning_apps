// Collections for cloud firestore db

// collection
const String USERS = "users";
// fields
const U_USER_ID = "userID";
const U_USER_NAME = "userName";
const U_EMAIL = "email";


// collection
const String POSTS = "posts";
// field
const String P_TIMESTAMP = "timestamp";
const String P_USER_ID = "userID";
const String P_DESCRIPTION = "description";
const String P_USER_NAME = "userName";
const String P_IMAGE_URL = "imageUrl";
// add before create post
const String P_POST_ID = "postID";

// collection
const String COMMENTS = "comments";
// field
const String C_TIMESTAMP = "timestamp";
const String C_USER_ID = "userID";
const String C_MESSAGE = "message";
const String C_USER_NAME = "userName";