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

module.exports = postsNasabah;
