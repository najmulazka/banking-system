const pool = require('../database/postgre');

function postsNasabah(namaLengkap, jenisKelamin, noTelp, email, alamat) {
  return new Promise(async (resolve, reject) => {
    try {
      let result = await pool.query('INSERT INTO nasabah (nama_lengkap, jenis_kelamin, no_telp, email, alamat) VALUES ($1,$2,$3,$4,$5) RETURNING *', [namaLengkap, jenisKelamin, noTelp, email, alamat]);
      return resolve(result.rows[0]);
    } catch (err) {
      return reject(err);
    }
  });
}

function indexNasabah() {
  return new Promise(async (resolve, reject) => {
    try {
      let result = await pool.query('SELECT * from nasabah ORDER BY nasabah_id ASC');
      return resolve(result.rows);
    } catch (err) {
      return reject(err);
    }
  });
}

function showNasabah(id) {
  return new Promise(async (resolve, reject) => {
    try {
      let result = await pool.query('SELECT * FROM nasabah WHERE nasabah_id = $1', [id]);
      if (!result.rows.length) return reject(`Post with id ${id} doesn't not exist`);

      return resolve(result.rows[0]);
    } catch (err) {
      return reject(err);
    }
  });
}

function updateNasabah(id, namaLengkap, jenisKelamin, noTelp, email, alamat) {
  return new Promise(async (resolve, reject) => {
    try {
      let result = await pool.query('UPDATE nasabah SET nama_lengkap = $1, jenis_kelamin = $2, no_telp = $3, email = $4, alamat = $5 WHERE nasabah_id = $6 RETURNING *', [namaLengkap, jenisKelamin, noTelp, email, alamat, id]);
      if (!result.rowCount) return reject(`Post with id ${id} doesn't not exist`);

      return resolve(result.rows[0]);
    } catch (err) {
      return reject(err);
    }
  });
}

function deleteNasabah(id) {
  return new Promise(async (resolve, reject) => {
    try {
      let result = await pool.query('DELETE FROM nasabah WHERE nasabah_id = $1', [id]);
      if (!result.rowCount) return reject(`Post with id ${id} doesn't not exist`);

      return resolve(`Post with id ${id} deleted`);
    } catch (err) {
      return reject(err);
    }
  });
}
module.exports = { postsNasabah, indexNasabah, showNasabah, updateNasabah, deleteNasabah };
