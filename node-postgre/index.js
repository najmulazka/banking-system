const { postsNasabah, indexNasabah, showNasabah, updateNasabah } = require('./helper/crud');

async function main() {
  try {
    // //Input data
    // let newPost = await postsNasabah('Najmul Azka', 'Laki-laki', '088823927579', 'najmul@gmail.com', 'Purbalingga');
    let newPost = await postsNasabah('Dea Lili', 'Perempuan', '084723927579', 'dea@gmail.com', 'Banyumas');
    console.log(newPost);

    // Melihat semua data nasabah
    let posts = await indexNasabah();
    console.log(posts);

    // Melihat data nasabah berdasarkan id
    let post = await showNasabah(1);
    console.log(post);

    // Mengupdate data nasabah
    let postUpdateNasabah = await updateNasabah('1', 'Tukiman', 'Laki-laki', '088823927579', 'najmulazka@gmail.com', 'Purbalingga');
    console.log(postUpdateNasabah);
  } catch (err) {
    console.log(err);
  }
}

main();
