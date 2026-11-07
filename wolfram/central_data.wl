(* Content-type: application/vnd.wolfram.mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Mathematica 13.3' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       158,          7]
NotebookDataLength[      9305,        254]
NotebookOptionsPosition[      8955,        240]
NotebookOutlinePosition[      9350,        256]
CellTagsIndexPosition[      9307,        253]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{
Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{
    RowBox[{"Exact", " ", "certificate", " ", 
     RowBox[{"data", ".", " ", "Each"}], " ", "pair", " ", 
     RowBox[{"{", 
      RowBox[{"a", ",", "b"}], "}"}], " ", "denotes", " ", "a"}], "+", 
    RowBox[{"b", " ", 
     RowBox[{
      RowBox[{"Sqrt", "[", "2", "]"}], "."}]}]}], " ", "*)"}], "\n", 
  RowBox[{
   RowBox[{
    RowBox[{"centralVariables", " ", "=", " ", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"15931364979", "/", "34359738368"}], ",", 
         RowBox[{
          RowBox[{"-", "906661197"}], "/", "4294967296"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"21037216693", "/", "34359738368"}], ",", 
         RowBox[{"63689437", "/", "4294967296"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"2726997779", "/", "17179869184"}], ",", 
         RowBox[{
          RowBox[{"-", "238358817"}], "/", "2147483648"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "4915390711"}], "/", "17179869184"}], ",", 
         RowBox[{"480274641", "/", "2147483648"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"1024229901", "/", "2147483648"}], ",", 
         RowBox[{
          RowBox[{"-", "160479437"}], "/", "536870912"}]}], "}"}], ",", "\n", 
       
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "42438509"}], "/", "4294967296"}], ",", 
         RowBox[{"4020291", "/", "536870912"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "2066781535"}], "/", "8589934592"}], ",", 
         RowBox[{"251193663", "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "1503275411"}], "/", "8589934592"}], ",", 
         RowBox[{"151509657", "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"15931364979", "/", "34359738368"}], ",", 
         RowBox[{
          RowBox[{"-", "906661197"}], "/", "4294967296"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"33877", "/", "131072"}], ",", 
         RowBox[{
          RowBox[{"-", "47593"}], "/", "262144"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"2726997779", "/", "17179869184"}], ",", 
         RowBox[{
          RowBox[{"-", "238358817"}], "/", "2147483648"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "19907340857"}], "/", "17179869184"}], ",", 
         RowBox[{"1802036947", "/", "2147483648"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "4915390711"}], "/", "17179869184"}], ",", 
         RowBox[{"480274641", "/", "2147483648"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"1024229901", "/", "2147483648"}], ",", 
         RowBox[{
          RowBox[{"-", "160479437"}], "/", "536870912"}]}], "}"}], ",", "\n", 
       
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "168744761"}], "/", "4294967296"}], ",", 
         RowBox[{"990609", "/", "33554432"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "768005741"}], "/", "8589934592"}], ",", 
         RowBox[{"70497639", "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"471431087", "/", "8589934592"}], ",", 
         RowBox[{
          RowBox[{"-", "1323369"}], "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "42438509"}], "/", "4294967296"}], ",", 
         RowBox[{"4020291", "/", "536870912"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "2066781535"}], "/", "8589934592"}], ",", 
         RowBox[{"251193663", "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"463139705", "/", "4294967296"}], ",", 
         RowBox[{
          RowBox[{"-", "6427827"}], "/", "134217728"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "39921497"}], "/", "2147483648"}], ",", 
         RowBox[{"7515711", "/", "134217728"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"443784019", "/", "4294967296"}], ",", 
         RowBox[{
          RowBox[{"-", "17314269"}], "/", "536870912"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"204618631", "/", "4294967296"}], ",", 
         RowBox[{
          RowBox[{"-", "813645"}], "/", "134217728"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "2066781535"}], "/", "8589934592"}], ",", 
         RowBox[{"251193663", "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"828862265", "/", "4294967296"}], ",", 
         RowBox[{
          RowBox[{"-", "4028913"}], "/", "33554432"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "1503275411"}], "/", "8589934592"}], ",", 
         RowBox[{"151509657", "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"6737389459", "/", "8589934592"}], ",", 
         RowBox[{
          RowBox[{"-", "577885337"}], "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "1503275411"}], "/", "8589934592"}], ",", 
         RowBox[{"151509657", "/", "1073741824"}]}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", "\n", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"6839009527", "/", "34359738368"}], ",", 
         RowBox[{"157095855", "/", "4294967296"}]}], "}"}]}], "}"}]}], ";"}], 
   "\n", 
   RowBox[{
    RowBox[{"centralContrast", " ", "=", " ", 
     RowBox[{"{", 
      RowBox[{"0", ",", "0", ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       RowBox[{"1", "/", "8"}], ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", 
       RowBox[{
        RowBox[{"-", "1"}], "/", "8"}], ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", "0", ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       RowBox[{
        RowBox[{"-", "1"}], "/", "8"}], ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", "0", ",", 
       RowBox[{"1", "/", "8"}], ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", "0", ",", "0", ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", 
       RowBox[{
        RowBox[{"-", "1"}], "/", "8"}], ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", "0", ",", 
       RowBox[{"1", "/", "8"}], ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       RowBox[{"1", "/", "8"}], ",", "0", ",", "0", ",", "0", ",", "0", ",", 
       "0", ",", 
       RowBox[{
        RowBox[{"-", "1"}], "/", "8"}]}], "}"}]}], ";"}]}]}]], "Input",Express\
ionUUID->"3b68019b-7867-4acf-9d92-7ea943c2e39a"]
},
WindowSize->{808, 911},
WindowMargins->{{44, Automatic}, {Automatic, 104}},
FrontEndVersion->"13.3 for Mac OS X ARM (64-bit) (April 11, 2023)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"4b00bf05-cc92-4da7-93ca-a8c63c721bcb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[558, 20, 8393, 218, 1039, "Input",ExpressionUUID->"3b68019b-7867-4acf-9d92-7ea943c2e39a"]
}
]
*)

