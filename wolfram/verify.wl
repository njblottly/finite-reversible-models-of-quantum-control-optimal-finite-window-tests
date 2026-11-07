(* Content-type: application/vnd.wolfram.mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Mathematica 13.3' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       158,          7]
NotebookDataLength[     17642,        542]
NotebookOptionsPosition[     17290,        528]
NotebookOutlinePosition[     17686,        544]
CellTagsIndexPosition[     17643,        541]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{
Cell[BoxData[
 RowBox[{
  RowBox[{"(*", 
   RowBox[{"Run", " ", "in", " ", 
    RowBox[{"Mathematica", ":", " ", 
     RowBox[{"wolframscript", "-", 
      RowBox[{"file", " ", 
       RowBox[{"wolfram", "/", 
        RowBox[{"verify", ".", "wl", "."}]}]}]}]}]}], "*)"}], 
  RowBox[{
   RowBox[{
    RowBox[{"ClearAll", "[", 
     RowBox[{
     "qAdd", ",", "qNeg", ",", "qSub", ",", "qMul", ",", "qScale", ",", 
      "qNonnegative", ",", "check"}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"here", "=", 
     RowBox[{"DirectoryName", "[", "$InputFileName", "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Get", "[", 
     RowBox[{"FileNameJoin", "[", 
      RowBox[{"{", 
       RowBox[{"here", ",", "\"\<central_data.wl\>\""}], "}"}], "]"}], "]"}], 
    ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"qAdd", "[", 
      RowBox[{"x_", ",", "y_"}], "]"}], ":=", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{
        RowBox[{"x", "[", 
         RowBox[{"[", "1", "]"}], "]"}], "+", 
        RowBox[{"y", "[", 
         RowBox[{"[", "1", "]"}], "]"}]}], ",", 
       RowBox[{
        RowBox[{"x", "[", 
         RowBox[{"[", "2", "]"}], "]"}], "+", 
        RowBox[{"y", "[", 
         RowBox[{"[", "2", "]"}], "]"}]}]}], "}"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"qNeg", "[", "x_", "]"}], ":=", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", 
        RowBox[{"x", "[", 
         RowBox[{"[", "1", "]"}], "]"}]}], ",", 
       RowBox[{"-", 
        RowBox[{"x", "[", 
         RowBox[{"[", "2", "]"}], "]"}]}]}], "}"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"qSub", "[", 
      RowBox[{"x_", ",", "y_"}], "]"}], ":=", 
     RowBox[{"qAdd", "[", 
      RowBox[{"x", ",", 
       RowBox[{"qNeg", "[", "y", "]"}]}], "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"qMul", "[", 
      RowBox[{"x_", ",", "y_"}], "]"}], ":=", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{
        RowBox[{
         RowBox[{"x", "[", 
          RowBox[{"[", "1", "]"}], "]"}], " ", 
         RowBox[{"y", "[", 
          RowBox[{"[", "1", "]"}], "]"}]}], "+", 
        RowBox[{"2", " ", 
         RowBox[{"x", "[", 
          RowBox[{"[", "2", "]"}], "]"}], " ", 
         RowBox[{"y", "[", 
          RowBox[{"[", "2", "]"}], "]"}]}]}], ",", 
       RowBox[{
        RowBox[{
         RowBox[{"x", "[", 
          RowBox[{"[", "1", "]"}], "]"}], " ", 
         RowBox[{"y", "[", 
          RowBox[{"[", "2", "]"}], "]"}]}], "+", 
        RowBox[{
         RowBox[{"x", "[", 
          RowBox[{"[", "2", "]"}], "]"}], " ", 
         RowBox[{"y", "[", 
          RowBox[{"[", "1", "]"}], "]"}]}]}]}], "}"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"qScale", "[", 
      RowBox[{"x_", ",", "a_"}], "]"}], ":=", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"a", " ", 
        RowBox[{"x", "[", 
         RowBox[{"[", "1", "]"}], "]"}]}], ",", 
       RowBox[{"a", " ", 
        RowBox[{"x", "[", 
         RowBox[{"[", "2", "]"}], "]"}]}]}], "}"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"qNonnegative", "[", "x_", "]"}], ":=", 
     RowBox[{"If", "[", 
      RowBox[{
       RowBox[{
        RowBox[{"x", "[", 
         RowBox[{"[", "2", "]"}], "]"}], ">=", "0"}], ",", 
       RowBox[{
        RowBox[{
         RowBox[{"x", "[", 
          RowBox[{"[", "1", "]"}], "]"}], ">=", "0"}], "||", 
        RowBox[{
         RowBox[{"2", " ", 
          RowBox[{
           RowBox[{"x", "[", 
            RowBox[{"[", "2", "]"}], "]"}], "^", "2"}]}], ">=", 
         RowBox[{
          RowBox[{"x", "[", 
           RowBox[{"[", "1", "]"}], "]"}], "^", "2"}]}]}], ",", 
       RowBox[{
        RowBox[{
         RowBox[{"x", "[", 
          RowBox[{"[", "1", "]"}], "]"}], ">=", "0"}], "&&", 
        RowBox[{
         RowBox[{
          RowBox[{"x", "[", 
           RowBox[{"[", "1", "]"}], "]"}], "^", "2"}], ">=", 
         RowBox[{"2", " ", 
          RowBox[{
           RowBox[{"x", "[", 
            RowBox[{"[", "2", "]"}], "]"}], "^", "2"}]}]}]}]}], "]"}]}], 
    ";"}], "\n", 
   RowBox[{
    RowBox[{"checks", "=", "0"}], ";"}], "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"check", "[", 
      RowBox[{"condition_", ",", "name_"}], "]"}], ":=", 
     RowBox[{"If", "[", 
      RowBox[{
       RowBox[{"TrueQ", "[", "condition", "]"}], ",", 
       RowBox[{"checks", "=", 
        RowBox[{"checks", "+", "1"}]}], ",", 
       RowBox[{
        RowBox[{"Print", "[", 
         RowBox[{"\"\<FAIL: \>\"", ",", "name"}], "]"}], ";", 
        RowBox[{"Quit", "[", "1", "]"}]}]}], "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Print", "[", 
     RowBox[{"\"\<Engine: \>\"", ",", "$Version"}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"cosines", "=", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"1", ",", "0"}], "}"}], ",", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{
          RowBox[{"-", "1"}], "/", "2"}], ",", 
         RowBox[{
          RowBox[{"-", "1"}], "/", "4"}]}], "}"}]}], "}"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"For", "[", 
     RowBox[{
      RowBox[{"n", "=", "2"}], ",", 
      RowBox[{"n", "<", "64"}], ",", 
      RowBox[{"n", "++"}], ",", 
      RowBox[{"AppendTo", "[", 
       RowBox[{"cosines", ",", 
        RowBox[{"qSub", "[", 
         RowBox[{
          RowBox[{"qScale", "[", 
           RowBox[{
            RowBox[{"qMul", "[", 
             RowBox[{
              RowBox[{"cosines", "[", 
               RowBox[{"[", "2", "]"}], "]"}], ",", 
              RowBox[{"Last", "[", "cosines", "]"}]}], "]"}], ",", "2"}], 
           "]"}], ",", 
          RowBox[{"cosines", "[", 
           RowBox[{"[", 
            RowBox[{"-", "2"}], "]"}], "]"}]}], "]"}]}], "]"}]}], "]"}], 
    ";"}], "\n", 
   RowBox[{
    RowBox[{"probabilities", "=", 
     RowBox[{"Table", "[", 
      RowBox[{
       RowBox[{"qMul", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"6", "/", "17"}], ",", 
           RowBox[{
            RowBox[{"-", "1"}], "/", "17"}]}], "}"}], ",", 
         RowBox[{"qSub", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{"1", ",", "0"}], "}"}], ",", 
           RowBox[{"cosines", "[", 
            RowBox[{"[", 
             RowBox[{"n", "+", "1"}], "]"}], "]"}]}], "]"}]}], "]"}], ",", 
       RowBox[{"{", 
        RowBox[{"n", ",", "0", ",", "63"}], "}"}]}], "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Print", "[", "\"\<Target recurrence evaluated.\>\"", "]"}], 
    ";"}], "\n", 
   RowBox[{
    RowBox[{"check", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"probabilities", "[", 
        RowBox[{"[", "1", "]"}], "]"}], "==", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}]}], ",", "\"\<p0\>\""}], "]"}], ";"}], 
   "\n", 
   RowBox[{
    RowBox[{"check", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"probabilities", "[", 
        RowBox[{"[", "2", "]"}], "]"}], "==", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"1", "/", "2"}], ",", "0"}], "}"}]}], ",", "\"\<p1\>\""}], 
     "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"eta", "=", 
     RowBox[{"Take", "[", 
      RowBox[{"centralVariables", ",", "8"}], "]"}]}], ";", 
    RowBox[{"z", "=", 
     RowBox[{"Take", "[", 
      RowBox[{"centralVariables", ",", 
       RowBox[{"{", 
        RowBox[{"9", ",", "44"}], "}"}]}], "]"}]}], ";", 
    RowBox[{"dist", "=", 
     RowBox[{"Last", "[", "centralVariables", "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"check", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"Fold", "[", 
        RowBox[{"qAdd", ",", 
         RowBox[{"{", 
          RowBox[{"0", ",", "0"}], "}"}], ",", "eta"}], "]"}], "==", 
       RowBox[{"{", 
        RowBox[{"1", ",", "0"}], "}"}]}], ",", "\"\<normalization\>\""}], 
     "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Do", "[", 
     RowBox[{
      RowBox[{"check", "[", 
       RowBox[{
        RowBox[{"qNonnegative", "[", "x", "]"}], ",", 
        "\"\<nonnegative variable\>\""}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"x", ",", "centralVariables"}], "}"}]}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Print", "[", "\"\<Basis signs evaluated.\>\"", "]"}], ";"}], 
   "\n", 
   RowBox[{
    RowBox[{"Do", "[", 
     RowBox[{
      RowBox[{"check", "[", 
       RowBox[{
        RowBox[{"qNonnegative", "[", 
         RowBox[{"qSub", "[", 
          RowBox[{
           RowBox[{"eta", "[", 
            RowBox[{"[", "q", "]"}], "]"}], ",", 
           RowBox[{"z", "[", 
            RowBox[{"[", 
             RowBox[{
              RowBox[{"q", 
               RowBox[{
                RowBox[{"(", 
                 RowBox[{"q", "-", "1"}], ")"}], "/", "2"}]}], "+", "r", "+", 
              "1"}], "]"}], "]"}]}], "]"}], "]"}], ",", 
        "\"\<readout capacity\>\""}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"q", ",", "1", ",", "8"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"r", ",", "0", ",", 
        RowBox[{"q", "-", "1"}]}], "}"}]}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Do", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"curve", "=", 
        RowBox[{"Fold", "[", 
         RowBox[{"qAdd", ",", 
          RowBox[{"{", 
           RowBox[{"0", ",", "0"}], "}"}], ",", 
          RowBox[{"Table", "[", 
           RowBox[{
            RowBox[{"z", "[", 
             RowBox[{"[", 
              RowBox[{
               RowBox[{"q", 
                RowBox[{
                 RowBox[{"(", 
                  RowBox[{"q", "-", "1"}], ")"}], "/", "2"}]}], "+", 
               RowBox[{"Mod", "[", 
                RowBox[{"n", ",", "q"}], "]"}], "+", "1"}], "]"}], "]"}], ",", 
            RowBox[{"{", 
             RowBox[{"q", ",", "1", ",", "8"}], "}"}]}], "]"}]}], "]"}]}], 
       ";", "\[IndentingNewLine]", 
       RowBox[{"err", "=", 
        RowBox[{"qSub", "[", 
         RowBox[{"curve", ",", 
          RowBox[{"probabilities", "[", 
           RowBox[{"[", 
            RowBox[{"n", "+", "1"}], "]"}], "]"}]}], "]"}]}], ";", 
       "\[IndentingNewLine]", 
       RowBox[{"check", "[", 
        RowBox[{
         RowBox[{"qNonnegative", "[", 
          RowBox[{"qSub", "[", 
           RowBox[{"dist", ",", "err"}], "]"}], "]"}], ",", 
         "\"\<upper probability band\>\""}], "]"}], ";", 
       "\[IndentingNewLine]", 
       RowBox[{"check", "[", 
        RowBox[{
         RowBox[{"qNonnegative", "[", 
          RowBox[{"qAdd", "[", 
           RowBox[{"dist", ",", "err"}], "]"}], "]"}], ",", 
         "\"\<lower probability band\>\""}], "]"}]}], ",", 
      RowBox[{"{", 
       RowBox[{"n", ",", "0", ",", "63"}], "}"}]}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Print", "[", "\"\<Primal bands evaluated.\>\"", "]"}], ";"}], 
   "\n", 
   RowBox[{
    RowBox[{"Do", "[", 
     RowBox[{
      RowBox[{"check", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"Total", "[", 
          RowBox[{"Table", "[", 
           RowBox[{
            RowBox[{"If", "[", 
             RowBox[{
              RowBox[{
               RowBox[{"Mod", "[", 
                RowBox[{"n", ",", "q"}], "]"}], "==", "r"}], ",", 
              RowBox[{"centralContrast", "[", 
               RowBox[{"[", 
                RowBox[{"n", "+", "1"}], "]"}], "]"}], ",", "0"}], "]"}], ",", 
            RowBox[{"{", 
             RowBox[{"n", ",", "0", ",", "63"}], "}"}]}], "]"}], "]"}], "==", 
         "0"}], ",", "\"\<vanishing residue sum\>\""}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"q", ",", "1", ",", "8"}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"r", ",", "0", ",", 
        RowBox[{"q", "-", "1"}]}], "}"}]}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"check", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"Total", "[", 
        RowBox[{"Abs", "[", "centralContrast", "]"}], "]"}], "==", "1"}], 
      ",", "\"\<contrast normalization\>\""}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"score", "=", 
     RowBox[{"Fold", "[", 
      RowBox[{"qAdd", ",", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", 
       RowBox[{"Table", "[", 
        RowBox[{
         RowBox[{"qScale", "[", 
          RowBox[{
           RowBox[{"probabilities", "[", 
            RowBox[{"[", 
             RowBox[{"n", "+", "1"}], "]"}], "]"}], ",", 
           RowBox[{"centralContrast", "[", 
            RowBox[{"[", 
             RowBox[{"n", "+", "1"}], "]"}], "]"}]}], "]"}], ",", 
         RowBox[{"{", 
          RowBox[{"n", ",", "0", ",", "63"}], "}"}]}], "]"}]}], "]"}]}], 
    ";"}], "\n", 
   RowBox[{
    RowBox[{"check", "[", 
     RowBox[{
      RowBox[{"score", "==", "dist"}], ",", 
      "\"\<matching exact primal and dual\>\""}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"check", "[", 
     RowBox[{
      RowBox[{"dist", "==", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"6839009527", "/", "34359738368"}], ",", 
         RowBox[{"157095855", "/", "4294967296"}]}], "}"}]}], ",", 
      "\"\<printed theorem value\>\""}], "]"}], ";"}], "\n", 
   "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"poly", "=", 
     RowBox[{"Total", "[", 
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"centralContrast", "[", 
          RowBox[{"[", 
           RowBox[{"n", "+", "1"}], "]"}], "]"}], " ", 
         RowBox[{"x", "^", "n"}]}], ",", 
        RowBox[{"{", 
         RowBox[{"n", ",", "0", ",", "63"}], "}"}]}], "]"}], "]"}]}], ";"}], 
   "\n", 
   RowBox[{
    RowBox[{"check", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"Expand", "[", 
        RowBox[{"poly", "-", 
         RowBox[{
          RowBox[{"x", "^", "6"}], 
          RowBox[{"(", 
           RowBox[{"1", "-", 
            RowBox[{"x", "^", "6"}]}], ")"}], 
          RowBox[{"(", 
           RowBox[{"1", "-", 
            RowBox[{"x", "^", "16"}]}], ")"}], 
          RowBox[{
           RowBox[{"(", 
            RowBox[{"1", "-", 
             RowBox[{"x", "^", "35"}]}], ")"}], "/", "8"}]}]}], "]"}], "==", 
       "0"}], ",", "\"\<factorization\>\""}], "]"}], ";"}], 
   "\[IndentingNewLine]", "\n", 
   RowBox[{
    RowBox[{
     RowBox[{"qRemainder", "[", 
      RowBox[{"coeff_", ",", "period_"}], "]"}], ":=", 
     RowBox[{"Module", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"arr", "=", "coeff"}], ",", "j"}], "}"}], ",", 
       RowBox[{
        RowBox[{"For", "[", 
         RowBox[{
          RowBox[{"j", "=", 
           RowBox[{"Length", "[", "arr", "]"}]}], ",", 
          RowBox[{"j", ">", "period"}], ",", 
          RowBox[{"j", "--"}], ",", 
          RowBox[{
           RowBox[{"arr", "[", 
            RowBox[{"[", 
             RowBox[{"j", "-", "period"}], "]"}], "]"}], "=", 
           RowBox[{
            RowBox[{"arr", "[", 
             RowBox[{"[", 
              RowBox[{"j", "-", "period"}], "]"}], "]"}], "+", 
            RowBox[{"arr", "[", 
             RowBox[{"[", "j", "]"}], "]"}]}]}]}], "]"}], ";", 
        "\[IndentingNewLine]", 
        RowBox[{"Take", "[", 
         RowBox[{"arr", ",", "period"}], "]"}]}]}], "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"coefficients", "=", 
     RowBox[{"CoefficientList", "[", 
      RowBox[{"poly", ",", "x"}], "]"}]}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Do", "[", 
     RowBox[{
      RowBox[{"check", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"Total", "[", 
          RowBox[{"Abs", "[", 
           RowBox[{"qRemainder", "[", 
            RowBox[{"coefficients", ",", "q"}], "]"}], "]"}], "]"}], "==", 
         "0"}], ",", "\"\<period divisibility\>\""}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"q", ",", "1", ",", "8"}], "}"}]}], "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Print", "[", 
     RowBox[{"\"\<Exact checks passed: \>\"", ",", "checks"}], "]"}], ";"}], 
   "\n", 
   RowBox[{
    RowBox[{"Print", "[", 
     RowBox[{"\"\<Optimal radius (a,b): \>\"", ",", "dist"}], "]"}], ";"}], 
   "\n", 
   RowBox[{
    RowBox[{"Print", "[", 
     RowBox[{"\"\<Optimal radius decimal: \>\"", ",", 
      RowBox[{"N", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"dist", "[", 
          RowBox[{"[", "1", "]"}], "]"}], "+", 
         RowBox[{
          RowBox[{"dist", "[", 
           RowBox[{"[", "2", "]"}], "]"}], " ", 
          RowBox[{"Sqrt", "[", "2", "]"}]}]}], ",", "20"}], "]"}]}], "]"}], 
    ";"}], "\n", 
   RowBox[{
    RowBox[{
    "Print", "[", 
     "\"\<Native Mathematica execution is established only when Engine above \
identifies it.\>\"", "]"}], ";"}], "\n", 
   RowBox[{
    RowBox[{"Print", "[", "\"\<PASS\>\"", "]"}], ";"}], "\n"}]}]], "Input",
 CellChangeTimes->{{4.0029996861759663`*^9, 
  4.002999746462369*^9}},ExpressionUUID->"098c940f-2e45-4254-9d97-\
90d0dff4e5b0"]
},
WindowSize->{808, 911},
WindowMargins->{{Automatic, 489}, {Automatic, 181}},
FrontEndVersion->"13.3 for Mac OS X ARM (64-bit) (April 11, 2023)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"60d09024-b7cc-4468-a286-0b3968fc6cbe"
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
Cell[558, 20, 16728, 506, 1291, "Input",ExpressionUUID->"098c940f-2e45-4254-9d97-90d0dff4e5b0"]
}
]
*)

