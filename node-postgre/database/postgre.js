const Pool = require('pg').Pool;

const pool = new Pool({
  user: 'budi',
  database: 'bank',
  password: 'budi',
  port: 5432,
  host: 'localhost',
});

module.exports = pool;
