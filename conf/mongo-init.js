// switch to the "tycho" db
db = db.getSiblingDB('tycho');

// create a dummy collection to force db creation
db.dummy.insertOne({ init: true });

// now create the user
db.createUser({
  user: 'tycho',
  pwd: 'tycho_pwd',
  roles: [
    {
      role: 'dbOwner',
      db: 'tycho',
    },
  ],
});
