function total_bill(bill_list) {

  // PUT YOUR CODE HERE
    var totalPrice = 0
    for (let i=0; i<bill_list.length; i++) {
        for (let j=0; j<bill_list[i].length; j++) {
            totalPrice += parseFloat(bill_list[i][j].price.slice(1))
        }
    }
    return totalPrice
}

module.exports = total_bill;
