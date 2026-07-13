SELECT  WorkStationName from MST_WorkStation 
inner join  MST_Line 
on MST_WorkStation. MST_Line_Id =MST_Line. MST_Line_Id 
where MST_Line. LineName =:LineName
and  MST_WorkStation. IsActive =1