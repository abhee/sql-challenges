---- Oracle Solution
With Q As (
    Select P.Age As Age, Min(W.Coins_Needed) As Min_Galleons, W.Power As Power
    From Wands W,
    Wands_Property P
    Where W.Code=P.Code
    And P.Is_Evil=0
    Group By W.Power, P.Age
)
Select W.Id, P.Age, W.Coins_Needed, W.Power
From Wands W
Join Wands_Property P
ON W.Code=P.Code
And P.Is_Evil=0
Join Q
ON P.Age=Q.Age
And W.Power=Q.Power
And W.Coins_Needed=Q.Min_Galleons
Order By W.Power Desc, P.Age Desc;


---- MySQL Solution
Select W.Id, P.Age, W.Coins_Needed, W.Power
From Wands W
Join Wands_Property P
ON W.Code=P.Code
And P.Is_Evil=0
Join (Select P.Age As Age, Min(W.Coins_Needed) As Min_Galleons, W.Power As Power
    From Wands W,
    Wands_Property P
    Where W.Code=P.Code
    And P.Is_Evil=0
    Group By W.Power, P.Age) Q
ON P.Age=Q.Age
And W.Power=Q.Power
And W.Coins_Needed=Q.Min_Galleons
Order By W.Power Desc, P.Age Desc;
