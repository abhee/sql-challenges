---- Oracle and MySQL Solution
SELECT Case 
  When Grade < 8 Then NULL
  Else Name
End,
Grade, Marks
FROM Students
  INNER JOIN Grades
  ON Marks BETWEEN Min_Mark AND Max_Mark
ORDER BY Grade DESC, Name, Marks;
