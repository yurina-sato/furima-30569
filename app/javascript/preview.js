document.addEventListener('DOMContentLoaded', function(){
  const ImageList = document.getElementById('image-list');
  if(ImageList != null) { // コンソールのaddEventListener of nullエラー対策(商品出品・編集ページ以外での読み込みを避ける)
    // 選択した画像を表示する関数
    const createImageHTML = (blob) => {
      // 画像を表示するためのdiv要素を生成
      const imageElement = document.createElement('div');
      imageElement.setAttribute('class', "image-element");
      let imageElementNum = document.querySelectorAll('.image-element').length;

      // 表示する画像を生成
      const blobImage = document.createElement('img');
      blobImage.setAttribute('src', blob);

      // ファイル選択ボタンを生成
      const inputHTML = document.createElement('input');
      inputHTML.setAttribute('id', `item_image_${imageElementNum}`);
      inputHTML.setAttribute('name', 'item[images][]');
      inputHTML.setAttribute('type', 'file');

      // 生成したHTMLの要素をブラウザに表示させる
      imageElement.appendChild(blobImage);
      imageElement.appendChild(inputHTML);
      ImageList.appendChild(imageElement);

      inputHTML.addEventListener('change', (e) => {
      
        file = e.target.files[0];
        blob = window.URL.createObjectURL(file);

        createImageHTML(blob);
      });
    };
    
    document.getElementById('item-image').addEventListener('change', function(e){
      
      // 画像情報をイベントハッシュから取得して定義、画像URLを生成
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);

      createImageHTML(blob);

    });
  };
});



