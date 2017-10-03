---- Oracle Solution
With Max_Score As (
    Select S.Hacker_Id, 
    S.Challenge_Id, 
    MAX(S.Score) as MaxScore
    From Submissions S
    Group By S.Hacker_Id, S.Challenge_Id
    Having MAX(S.Score) != 0
)
Select H.Hacker_Id,
Name,
SUM(ms.MaxScore)
From Hackers H,
Max_Score ms
Where H.Hacker_Id=ms.Hacker_Id
Group By H.Hacker_Id, Name
Order By SUM(ms.MaxScore) DESC, H.Hacker_Id ASC;



----- MySQL Solution
Select H.Hacker_Id,
Name,
SUM(MaxScore) as TotalScore
From Hackers H,
(Select Hacker_Id, 
    Challenge_Id, 
    MAX(Score) as MaxScore
    From Submissions
    Group By Hacker_Id, Challenge_Id
    Having MaxScore != 0) As T
Where H.Hacker_Id=T.Hacker_Id
Group By H.Hacker_Id
Order By SUM(MaxScore) DESC, H.Hacker_Id ASC
