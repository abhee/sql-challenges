---- Oracle solution
With T1 As (
    Select Hacker_Id, count(*) As TotalChallenges From Challenges Group By Hacker_Id
)
Select H.Hacker_Id, Name, 
count(challenge_id) as TotalChallenges
From Hackers H,
Challenges C
Where H.Hacker_id=C.Hacker_Id
Group By H.Hacker_id, Name
Having count(challenge_id) in
(Select TotalChallenges From T1
    Group By TotalChallenges
    Having (TotalChallenges=(Select MAX(TotalChallenges) From T1)) 
    OR (TotalChallenges<(Select MAX(TotalChallenges) From T1) AND Count(Hacker_Id)=1))
Order By count(challenge_id) DESC, Hacker_Id;



---- MySql Solution
Select H.Hacker_Id, Name, count(challenge_id) as TotalChallenges
From Hackers H,
Challenges C
Where H.Hacker_id=C.Hacker_Id
Group By Hacker_id
Having TotalChallenges in
(Select TotalChallenges
    From 
    (Select Hacker_Id, count(*) As TotalChallenges From Challenges Group By Hacker_Id) As T
    Group By TotalChallenges
    Having (TotalChallenges=(Select MAX(Cnt) From
            (Select count(*) As Cnt From Challenges Group By Hacker_Id) A))
    OR (TotalChallenges<(Select MAX(Cnt) From
            (Select count(*) As Cnt From Challenges Group By Hacker_Id) A) 
        AND Count(Hacker_Id)=1))

Order By count(challenge_id) DESC, Hacker_Id
