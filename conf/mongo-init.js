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
