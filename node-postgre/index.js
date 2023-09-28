const { postsNasabah, indexNasabah } = require('./helper/crud');

async function main() {
  try {
    // //Input data
    // let post = await postsNasabah('Najmul Azka', 'Laki-laki', '088823927579', 'najmul@gmail.com', 'Purbalingga');
    // let newPost = await postsNasabah('Dea Lili', 'Perempuan', '084723927579', 'dea@gmail.com', 'Banyumas');
    // console.log(newPost);

    let posts = await indexNasabah();
    console.log(posts);
  } catch (err) {
    console.log(err);
  }
}

main();
