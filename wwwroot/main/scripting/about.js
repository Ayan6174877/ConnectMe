$(document).ready(function(){

setInterval(changeword1, 5000);
var i = 1;
wordarray = ["#EmpowerThem","#HelpThemGrow","#MakeThemSuccessful"];
function changeword1(){
    currentword = $("#about1_change").html();
    wordlength = currentword.length ;
    
    while(wordlength > 0){
        newword =  currentword.slice(0, wordlength - 1);
        $("#about1_change").html(newword);

        wordlength--;
    }
    
   triggerword(i);
    i++;

    if(i == 3){
        i = 0;
    }
}

function triggerword(i){
    textchange = wordarray[i];
    $("#about1_change").html(textchange);
}

setInterval(changeword2, 5000);
var j = 1;
wordarray1 = ["Simplifying the way professionals networking happens","Keeping hiring process transparent","Making decision making easier"];
function changeword2(){
    currentword = $("#about1_change").html();
    wordlength = currentword.length ;
    
    while(wordlength > 0){
        newword =  currentword.slice(0, wordlength - 1);
        $("#about2_change").html(newword);

        wordlength--;
    }
    
   triggerword1(j);
    j++;

    if(j == 3){
        j = 0;
    }
}

function triggerword1(i){
    textchange = wordarray1[i];
    $("#about2_change").html(textchange);
}


});