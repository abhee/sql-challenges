---- MySQL Solution
Select H.Hacker_Id, Name 
From Hackers H
   Inner Join Submissions S
     ON H.Hacker_Id=S.Hacker_Id
   Inner Join Challenges C
     ON S.Challenge_Id=C.Challenge_ID
   Inner Join Difficulty D
     ON C.Difficulty_Level=D.Difficulty_Level
Where S.Score=D.Score
   Group By H.Hacker_Id, Name
     Having Count(S.Challenge_Id) > 1
Order By Count(S.Challenge_Id) DESC, H.Hacker_Id


---- MySQL Solution 2
Select H.Hacker_Id, H.Name 
From Hackers H, 
     Submissions S,
     Challenges C,
     Difficulty D
Where H.Hacker_Id=S.Hacker_Id
   And S.Challenge_Id=C.Challenge_ID
   And C.Difficulty_Level=D.Difficulty_Level
   And S.Score=D.Score
Group By H.Hacker_Id, H.Name
   Having Count(S.Challenge_Id) > 1
Order By Count(S.Challenge_Id) DESC, H.Hacker_Id
