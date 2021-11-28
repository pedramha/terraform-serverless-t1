function letMeCallYou()
{
    const Http = new XMLHttpRequest();
    const url='https://db81xqfspe.execute-api.eu-central-1.amazonaws.com/prod/hello';
    Http.open("GET", url);
    Http.send();
    
    Http.onreadystatechange = (e) => {
      console.log(Http.responseText)
    }
}