
function sum(list) {

  // PUT YOUR CODE HERE
	var sum = 0;
	var l = list.length;
	for (var i=0; i<l; i++) {
		sum += parseInt(list[i]);
	}
	return sum;  
}

module.exports = sum;
