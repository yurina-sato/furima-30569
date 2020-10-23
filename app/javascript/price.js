function price (){
  const itemPrice = document.getElementById("item-price");
  if(itemPrice != null) { // コンソールのaddEventListener of nullエラー対策(商品出品・編集ページ以外での読み込みを避ける)
    itemPrice.addEventListener("keyup", () => {
      const priceVal = itemPrice.value; //入力金額を取得
      const addTaxPrice = document.getElementById("add-tax-price"); //手数料を表示するHTMLを取得
      const profit = document.getElementById("profit"); //販売利益をを表示するHTMLを取得
      const tax = 0.1; //消費税を定義
      const sellTax = Math.floor(priceVal * tax); //販売手数料の計算
      const sellProfit = priceVal - sellTax; //販売利益の計算

      addTaxPrice.innerHTML = `${sellTax}`;
      profit.innerHTML = `${sellProfit}`;
    });
  };
};
  
setInterval(price, 1000);

