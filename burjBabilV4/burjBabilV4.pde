String[] translateMe;
ArrayList translated;
ArrayList original;
ArrayList originalAsText;
ArrayList translatedCorrected;
String languageCode="sv";
//i%20am
String objFile[];
float myMin=100000;
float myMax=0;
String breaker="%20))%20";
String breaks="%20bbbbb%20";
PrintWriter output;
PrintWriter outputAPI;
PrintWriter originalFile;
PrintWriter outputTextOBJ;

int incTrans=0;
int counter=0;
int limiter=150;
String guardian;
String[] loader;
int NUM_TEXTS=15;
int foundV=0;
//guys key AIzaSyBC5hn3FdVjEa8V_phDhKQF6w-aT5x0X5I
///my key AIzaSyAtOf1n2bUYvR_k7HGTNrWsXA57-H6ttW4
//remember 100 000 characters a day
String API_KEY="*****";
ArrayList resultFromAPI;

void setup() {
  //writer for obj file
  output = createWriter("into_"+languageCode+".obj"); 
  
  //logs results from api
  outputAPI = createWriter("dumpAPI.txt"); 
  originalFile= createWriter("originalFile.txt"); 
  outputTextOBJ= createWriter("outputTextOBJ.txt"); 
  
  translated = new ArrayList();  // Create an empty ArrayList
  originalAsText= new ArrayList();
  //holds latest api result for file saving
  resultFromAPI = new ArrayList();  // Create an empty ArrayList
  translatedCorrected= new ArrayList();
  //holds the original obj file
  original = new ArrayList();  // Create an empty ArrayList
//AIzaSyB6h4qauRpkR9Y7g_miyhjdCNbIADKAVDE


//https://www.googleapis.com/language/translate/v2?key=AIzaSyB6h4qauRpkR9Y7g_miyhjdCNbIADKAVDE&q=hello%20world&source=en&target=de
  
  //translate me holds each text which is fed to the API it happens in about 10 chunks normally depending on the model
  
  //TODO CHANGE TRANSLATE ME TO AN ARRAY LIST YOU LAZY BASTARD
  translateMe= new String[NUM_TEXTS];
  for (int i =0;i<translateMe.length;i++) {

    translateMe[i]="";
  }

  shiftMyObj();
  writeFile();
}


void draw() {
}

void shiftMyObj() {
  String[] alphabet= {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
  };


  //objFile=loadStrings("25x25Tower.obj");
  objFile=loadStrings("finalTower.obj");


  for (int i=0;i<objFile.length;i++) {

    String thisLine=objFile[i];
    String[] pieces=splitTokens(thisLine, " ");

    try {

      if (pieces[0].equals("v")) {
        original.add(thisLine);
        int a =int(pieces[1])+12;
        int b =int(pieces[2])+12;
        int c =int(pieces[3])+12;

       //println(a + " " + alphabet[a]);
        //here the obj file line is added to the chunk sent to the API as letters, each line is delimited with "))"
        thisLine=alphabet[a]+alphabet[b]+alphabet[c]+breaker;
        originalFile.println(thisLine);
        originalAsText.add(thisLine);
        //the limiter is to break the text into API manageable sizes - bout 150 *5 charachters

        if (counter<limiter) {
          translateMe[incTrans]+=thisLine;
          counter++;
        }
        if (counter==limiter) {
          translateMe[incTrans]+=alphabet[a]+alphabet[b]+alphabet[c];

          incTrans++;
          counter=0;
          // counter++;
        }

       
      }
    }
    catch(Exception e) {
    }
  }

originalFile.flush();
originalFile.close();
  println("counter "+counter);
  
  //for each chunk of the text
  //ToDO this is just for testing
 //  for (int i=0;i<1;i++) {
 for (int i=0;i<translateMe.length;i++) {
    //for (int i=0;i<1;i++) { 
    if (translateMe[i].equals("")==false&&translateMe[i].length()>0) {
     // println(i+" "+translateMe[i]);
      //println(loadStrings("https://www.googleapis.com/language/translate/v2?key=AIzaSyB6h4qauRpkR9Y7g_miyhjdCNbIADKAVDE&q="+translateMe[i]+"&source=en&target=de"));
    
    
    String[] returnedFromCall=loadStrings("https://www.googleapis.com/language/translate/v2?key="+API_KEY+"&q="+translateMe[i]+"&source=en&target="+languageCode);
   //String[] returnedFromCall=loadStrings("dumpAPI2.txt");
    
  //  println(returnedFromCall);
    
      String[] justThePoints=splitTokens(returnedFromCall[4], "):");
      
       
     
    //  for(int j=1;j<justThePoints.length;j++){
   //  resultFromAPI.add( justThePoints[j] );
  //    
   // }
      // println(justThePoints[0]+" 0  "+justThePoints[1]+" 1 "+justThePoints[2]+" 2 "+justThePoints[3]);

      //ignore the first space it just reads "translatedText"
      for (int j =1;j<justThePoints.length;j++) {
       translated.add(justThePoints[j]);
      }
     
    }
  }
  for(int i=0;i<translated.size();i++){
   outputAPI.println((String)translated.get(i)); 
    println("translated "+(String)translated.get(i)); 
  }
  outputAPI.flush();
  outputAPI.close();

}

void writeFile() {

 //check for descrepancies between the 2 files here
 
 for(int i=0;i<translated.size();i++){
   
 
 //  String orig=(String)originalAsText.get(i);
   String newT=(String)translated.get(i);
   
   newT=newT.toLowerCase();
   //if(orig.equals(newT)==false)  ;
 //   println( "originalAsText1 "+(String)originalAsText.get(i)+ " translate1 "+newT);
   if(newT.equals("") || newT.length()<3   ){
    
    println("PROBLEM");  
   
   
   }
   
   else{
     
    translatedCorrected.add(newT);
   
 }
   // int(newT.charAt(1))>60 ==false 
 }
/* for(int i=0;i<translatedCorrected.size();i++){
      String orig=(String)originalAsText.get(i);
       String newT=(String)translatedCorrected.get(i);
    println( "originalAsText "+orig+ " translated "+newT);
 }*/
 
  int whereInFile=0;
  for (int i=0;i<objFile.length;i++) {

    String thisLine=objFile[i];
    String[] pieces=splitTokens(thisLine, " ");

    try {
      //if its the first line that has a v started printing from the array instead of the original file
      if (pieces[0].equals("v")&&foundV==0) {
        for (int j=0;j< translatedCorrected.size();j++) {
          String word=(String)translatedCorrected.get(j);

        println("word.charAt(1) "+word.charAt(1)+ " "+word);
             float x= float(word.charAt(1)) ;
             float y=int(word.charAt(2)) ;
             float z=float(word.charAt(3)) ;
            
            
            String originalLine=(String)original.get(j);
            String[] pieces1=splitTokens(originalLine, " ");
            float a =float(pieces1[1]);
             float b = float(pieces1[2]);
             float c =int(pieces1[3]);
            println("word contains "+word +" "+x+" "+y+" "+z);
            //check that the cahracters aren't wonky and outside our range
               String replacedLine="";
            if(x<61 || y<61 || z<61){
              if(x<61 ) x=a;
              if(y<61 ) y=b;
              if(z<61 ) z=c;
             println("CAUGHT ONE");
              // replacedLine="v "+str((a))+".00 "+str((b))+".00 "+str((c))+".00 ";
               replacedLine="v "+str((a))+" "+str((b))+" "+str((c))+" ";
            }
            else{
            //replacedLine="v "+str((a+x)-109)+".00 "+str((b+y)-109)+".00 "+str((c+z)-109)+".00 ";
          replacedLine="v "+str((a+x)-109)+" "+str((b+y)-109)+" "+str((c+z)-109)+" ";  
          }
          output.println(replacedLine);
          outputTextOBJ.println(word);
          
            foundV++;
       
        }
      }
      else {

        output.println(objFile[i]);
      }
    }
    catch(Exception e) {
    }
    
   // whereInFile++;
  }
outputTextOBJ.flush();
outputTextOBJ.close();
  output.flush();
  output.close();
}

