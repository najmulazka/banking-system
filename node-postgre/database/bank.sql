-- MEMBUAT DATABASE BANK
CREATE DATABASE bank;

-- MEMBUAT TABLE NASABAH
CREATE TABLE nasabah(
    nasabah_id BIGSERIAL NOT NULL PRIMARY KEY,
    nama_lengkap VARCHAR (100) NOT NULL,
    jenis_kelamin VARCHAR (25) NOT NULL,
    no_telp VARCHAR (25) NOT NULL UNIQUE,
    email VARCHAR (100) NOT NULL UNIQUE,
    alamat TEXT NOT NULL
);

-- MEMBUAT TABLE AKUN DAN BERELASI DENGAN TABLE NASABAH
CREATE TABLE akun(
    akun_id BIGSERIAL NOT NULL PRIMARY KEY,
    nasabah_id BIGINT NOT NULL,
    jenis_akun VARCHAR (50) NOT NULL,
    saldo FLOAT NOT NULL,
    CONSTRAINT fk_akun_relation_nasabah FOREIGN KEY (nasabah_id) REFERENCES nasabah (nasabah_id)
);

-- MEMBUAT TABLE TRANSAKSI DAN BERELASI DENGAN TABLE AKUN
CREATE TABLE transaksi(
    transaksi_id BIGSERIAL NOT NULL PRIMARY KEY,
    akun_id BIGINT NOT NULL,
    tanggal_transaksi DATE NOT NULL,
    jenis_transaksi VARCHAR (25) NOT NULL,
    jumlah_transaksi FLOAT NOT NULL,
    akun_id_penerima BIGINT,
    CONSTRAINT fk_transaksi_relation_akun FOREIGN KEY (akun_id) REFERENCES akun (akun_id)
);

-- MEMBUAT PROSEDURE INPUT TRANSAKSI PENARIKAN(TERHUBUNG KESALDO AKUN)
CREATE PROCEDURE input_transaksi_penarikan(
	akun_id_penarik BIGINT, 
	tanggal_penarikan DATE,
	jumlah_penarikan FLOAT
    )
    LANGUAGE plpgsql 
    AS $$
    BEGIN
	    INSERT INTO transaksi (akun_id, tanggal_transaksi, jenis_transaksi, jumlah_transaksi) VALUES
	    (akun_id_penarik, tanggal_penarikan, 'penarikan', jumlah_penarikan);
	    UPDATE akun SET saldo = saldo - jumlah_penarikan WHERE akun_id = akun_id_penarik;
    COMMIT;
    END;$$
    ;

-- MEMBUAT PROCEDURE INPUT TRANSAKSI SETORAN(TERHUBUNG KESALDO AKUN)
CREATE PROCEDURE input_transaksi_setoran(
	akun_id_penyetor BIGINT, 
	tanggal_transaksi_penyetoran DATE,
	jumlah_transaksi_penyetoran FLOAT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO transaksi (akun_id, tanggal_transaksi, jenis_transaksi, jumlah_transaksi) VALUES 
        (akun_id_penyetor, tanggal_transaksi_penyetoran, 'setoran', jumlah_transaksi_penyetoran);
        UPDATE akun SET saldo = saldo + jumlah_transaksi_penyetoran WHERE akun_id = akun_id_penyetor;
    COMMIT;
    END;$$
    ;

-- MEMBUAT PROSEDURE INPUT TRANSAKSI TRANSFER(TERHUBUNG KESALDO AKUN PENGIRIM DAN AKUN PENERIMA)
CREATE PROCEDURE input_transaksi_transfer(
	sender_id BIGINT, 
	tanggal_transfer DATE,
	jumlah_transfer FLOAT,
	recipient_id BIGINT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
	    INSERT INTO transaksi (akun_id, tanggal_transaksi, jenis_transaksi, jumlah_transaksi, akun_id_penerima) VALUES 
	    (sender_id, tanggal_transfer, 'transfer', jumlah_transfer, recipient_id);
	    UPDATE akun SET saldo = saldo + jumlah_transfer WHERE akun_id = recipient_id;
	    UPDATE akun SET saldo = saldo - jumlah_transfer WHERE akun_id = sender_id;
    COMMIT;
    END;$$
    ;

-- MEMBUAT PROSEDURE HAPUS NASABAH (AKAN MENGHAPUS DATA NASABAH, AKUN DAN TRANSAKSI YANG BERKAITAN DENGAN NASABAH TERSEBUT)
CREATE PROCEDURE hapus_nasabah(
    delete_nasabah_id BIGINT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM transaksi WHERE akun_id IN (SELECT akun_id FROM akun WHERE nasabah_id = delete_nasabah_id);
	    DELETE FROM akun WHERE nasabah_id = delete_nasabah_id;
	    DELETE FROM nasabah WHERE nasabah_id = delete_nasabah_id;
    COMMIT;
    END;$$
    ;

-- MEMBUAT PROCEDURE HAPUS AKUN (AKAN MENGHAPUS DATA AKUN, DAN TRANSAKSI YANG BERKAITAN DENGAN AKUN TERSEBUT)
CREATE PROCEDURE hapus_akun(
    delete_akun_id bigint
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
	DELETE FROM transaksi WHERE akun_id = delete_akun_id;
	DELETE FROM akun WHERE akun_id = delete_akun_id ;
    COMMIT;
    END;$$
;