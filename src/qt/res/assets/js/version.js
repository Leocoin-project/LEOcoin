/**
 * Created by makoric on 12.7.2017.
 */
var input = document.createElement("input");
input.type = "hidden";
input.id= "new-version-element";
input.value= "v3.0.0.1"; // LEOCoin version number
var body=document.getElementsByTagName('body')[0];
body.appendChild(input);