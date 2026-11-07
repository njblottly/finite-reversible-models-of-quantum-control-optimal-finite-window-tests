(* Content-type: application/vnd.wolfram.mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Mathematica 13.3' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       158,          7]
NotebookDataLength[      8601,        236]
NotebookOptionsPosition[      8251,        222]
NotebookOutlinePosition[      8647,        238]
CellTagsIndexPosition[      8604,        235]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{
Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{
    RowBox[{
    "Independent", " ", "Mathematica", " ", "implementation", " ", "of", " ", 
     "the", " ", "finite"}], "-", 
    RowBox[{"window", " ", "primal", " ", 
     RowBox[{"LP", ".", "\n", "   ", "This"}], " ", "file", " ", "requires", 
     " ", "a", " ", "native", " ", "Mathematica", " ", 
     RowBox[{"kernel", "."}]}]}], "*)"}], "\n", 
  RowBox[{
   RowBox[{
    RowBox[{"ClearAll", "[", "WindowModel", "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"WindowModel", "[", 
      RowBox[{"m_Integer", ",", "d_Integer", ",", 
       RowBox[{"reset_", ":", "False"}]}], "]"}], " ", ":=", " ", 
     RowBox[{"Module", "[", "\n", " ", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
        "eta", ",", "z", ",", "t", ",", "n", ",", "q", ",", "r", ",", "c1", 
         ",", "cc", ",", "p", ",", "c", ",", "a", ",", "vars", ",", "cons", 
         ",", "result", ",", "ee", ",", "zz", ",", "tt"}], "}"}], ",", "\n", 
       " ", 
       RowBox[{
        RowBox[{"If", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"m", "<", "1"}], " ", "||", " ", 
           RowBox[{"d", "<", "1"}]}], ",", 
          RowBox[{"Return", "[", "$Failed", "]"}]}], "]"}], ";", "\n", " ", 
        RowBox[{"eta", "=", 
         RowBox[{"Array", "[", 
          RowBox[{"ee", ",", "m"}], "]"}]}], ";", 
        RowBox[{"z", "=", 
         RowBox[{"Table", "[", 
          RowBox[{
           RowBox[{"Array", "[", 
            RowBox[{
             RowBox[{
              RowBox[{"zz", "[", 
               RowBox[{"q", ",", "#"}], "]"}], "&"}], ",", "q"}], "]"}], ",", 
           
           RowBox[{"{", 
            RowBox[{"q", ",", "1", ",", "m"}], "}"}]}], "]"}]}], ";", 
        RowBox[{"t", "=", "tt"}], ";", "\n", " ", 
        RowBox[{"c1", "=", 
         RowBox[{
          RowBox[{"-", 
           RowBox[{"(", 
            RowBox[{"2", "+", 
             RowBox[{"Sqrt", "[", "2", "]"}]}], ")"}]}], "/", "4"}]}], ";", 
        RowBox[{"a", "=", 
         RowBox[{
          RowBox[{"(", 
           RowBox[{"6", "-", 
            RowBox[{"Sqrt", "[", "2", "]"}]}], ")"}], "/", "17"}]}], ";", 
        "\n", " ", 
        RowBox[{"c", "=", 
         RowBox[{"Join", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{"1", ",", "c1"}], "}"}], ",", 
           RowBox[{"ConstantArray", "[", 
            RowBox[{"0", ",", 
             RowBox[{"Max", "[", 
              RowBox[{"0", ",", 
               RowBox[{"d", "-", "2"}]}], "]"}]}], "]"}]}], "]"}]}], ";", 
        "\n", " ", 
        RowBox[{"Do", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"c", "[", 
            RowBox[{"[", 
             RowBox[{"n", "+", "1"}], "]"}], "]"}], "=", 
           RowBox[{"Expand", "[", 
            RowBox[{
             RowBox[{"2", " ", "c1", " ", 
              RowBox[{"c", "[", 
               RowBox[{"[", "n", "]"}], "]"}]}], "-", 
             RowBox[{"c", "[", 
              RowBox[{"[", 
               RowBox[{"n", "-", "1"}], "]"}], "]"}]}], "]"}]}], ",", 
          RowBox[{"{", 
           RowBox[{"n", ",", "2", ",", 
            RowBox[{"d", "-", "1"}]}], "}"}]}], "]"}], ";", "\n", " ", 
        RowBox[{"p", "=", 
         RowBox[{"Table", "[", 
          RowBox[{
           RowBox[{"a", 
            RowBox[{"(", 
             RowBox[{"1", "-", 
              RowBox[{"c", "[", 
               RowBox[{"[", 
                RowBox[{"n", "+", "1"}], "]"}], "]"}]}], ")"}]}], ",", 
           RowBox[{"{", 
            RowBox[{"n", ",", "0", ",", 
             RowBox[{"d", "-", "1"}]}], "}"}]}], "]"}]}], ";", "\n", " ", 
        RowBox[{"vars", "=", 
         RowBox[{"Join", "[", 
          RowBox[{"eta", ",", 
           RowBox[{"Flatten", "[", "z", "]"}], ",", 
           RowBox[{"{", "t", "}"}]}], "]"}]}], ";", "\n", " ", 
        RowBox[{"cons", "=", 
         RowBox[{"Join", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{
              RowBox[{"Total", "[", "eta", "]"}], "==", "1"}], ",", 
             RowBox[{"t", ">=", "0"}]}], "}"}], ",", 
           RowBox[{"Thread", "[", 
            RowBox[{"eta", ">=", "0"}], "]"}], ",", "\n", "   ", 
           RowBox[{"Flatten", "[", 
            RowBox[{"Table", "[", 
             RowBox[{
              RowBox[{"Join", "[", 
               RowBox[{
                RowBox[{"Thread", "[", 
                 RowBox[{
                  RowBox[{"z", "[", 
                   RowBox[{"[", "q", "]"}], "]"}], ">=", "0"}], "]"}], ",", 
                RowBox[{"Thread", "[", 
                 RowBox[{
                  RowBox[{"z", "[", 
                   RowBox[{"[", "q", "]"}], "]"}], "<=", 
                  RowBox[{"eta", "[", 
                   RowBox[{"[", "q", "]"}], "]"}]}], "]"}]}], "]"}], ",", 
              RowBox[{"{", 
               RowBox[{"q", ",", "1", ",", "m"}], "}"}]}], "]"}], "]"}], ",", 
           "\n", "   ", 
           RowBox[{"If", "[", 
            RowBox[{"reset", ",", 
             RowBox[{"Table", "[", 
              RowBox[{
               RowBox[{
                RowBox[{"z", "[", 
                 RowBox[{"[", 
                  RowBox[{"q", ",", "1"}], "]"}], "]"}], "==", "0"}], ",", 
               RowBox[{"{", 
                RowBox[{"q", ",", "1", ",", "m"}], "}"}]}], "]"}], ",", 
             RowBox[{"{", "}"}]}], "]"}], ",", "\n", "   ", 
           RowBox[{"Flatten", "[", 
            RowBox[{"Table", "[", 
             RowBox[{
              RowBox[{
               RowBox[{"cc", "=", 
                RowBox[{"Sum", "[", 
                 RowBox[{
                  RowBox[{"z", "[", 
                   RowBox[{"[", 
                    RowBox[{"q", ",", 
                    RowBox[{
                    RowBox[{"Mod", "[", 
                    RowBox[{"n", ",", "q"}], "]"}], "+", "1"}]}], "]"}], 
                   "]"}], ",", 
                  RowBox[{"{", 
                   RowBox[{"q", ",", "1", ",", "m"}], "}"}]}], "]"}]}], ";", 
               "\n", "     ", 
               RowBox[{"{", 
                RowBox[{
                 RowBox[{
                  RowBox[{"cc", "-", 
                   RowBox[{"p", "[", 
                    RowBox[{"[", 
                    RowBox[{"n", "+", "1"}], "]"}], "]"}]}], "<=", "t"}], ",", 
                 RowBox[{
                  RowBox[{
                   RowBox[{"p", "[", 
                    RowBox[{"[", 
                    RowBox[{"n", "+", "1"}], "]"}], "]"}], "-", "cc"}], "<=", 
                  "t"}]}], "}"}]}], ",", 
              RowBox[{"{", 
               RowBox[{"n", ",", "0", ",", 
                RowBox[{"d", "-", "1"}]}], "}"}]}], "]"}], "]"}]}], "]"}]}], 
        ";", "\n", " ", 
        RowBox[{"result", "=", 
         RowBox[{"Minimize", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{"t", ",", 
             RowBox[{"And", "@@", "cons"}]}], "}"}], ",", "vars"}], "]"}]}], 
        ";", "result"}]}], "]"}]}], ";"}], "\n", 
   RowBox[{"(*", " ", 
    RowBox[{"Examples", ":", "\n", "   ", 
     RowBox[{
      RowBox[{"WindowModel", "[", 
       RowBox[{"8", ",", "64"}], "]"}], "\n", "   ", 
      RowBox[{"WindowModel", "[", 
       RowBox[{"8", ",", "64", ",", "True"}], "]"}], "\n", "   ", "Evaluate", 
      " ", "numerically", " ", "with", " ", 
      RowBox[{"N", "[", 
       RowBox[{"result", ",", "20"}], "]"}], " ", "after", " ", "exact", " ", 
      "optimisation", " ", 
      RowBox[{"completes", "."}]}]}], "\n", "*)"}]}]}]], "Input",
 CellChangeTimes->{{4.003000678338296*^9, 
  4.003000692965644*^9}},ExpressionUUID->"3afddef7-4746-4adc-a5d0-\
39bc3507b0ac"]
},
WindowSize->{808, 911},
WindowMargins->{{Automatic, 223}, {167, Automatic}},
FrontEndVersion->"13.3 for Mac OS X ARM (64-bit) (April 11, 2023)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"b2cfacde-703f-4ab8-8400-1e98ab0bab14"
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
Cell[558, 20, 7689, 200, 493, "Input",ExpressionUUID->"3afddef7-4746-4adc-a5d0-39bc3507b0ac"]
}
]
*)

