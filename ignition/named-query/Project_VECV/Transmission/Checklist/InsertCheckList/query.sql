declare @SequenceNum int;
declare @TMcode nvarchar(50) =  :TMcode;
declare @Parameter nvarchar(max) =  :Parameter;
declare @LowerLimit float =  :LowerLimit;
declare @UpperLimit float =  :UpperLimit ;
declare @WS int =  :WS ;
declare @Area int =  :Area ;
declare @Line int =  :Line ;
declare @CreatedBy int = :CreatedBy ;



declare @TMCodeId int;
declare @ETCodeId int;

set @TMCodeId = (select M_BOM_Id from M_BOM where M_BOMNumber =@TMcode and IsActive = 1 and IsDeleted = 0)
set @ETCodeId = (select G.MST_Model_Id from REL_GroupBom as G
inner join MST_Model as M on M.MST_Model_Id = G.MST_Model_Id 
where G.M_BOM_Id = @TMCodeId and M.IsActive = 1)
if @TMCodeId is not null
	begin
		if exists( select MST_Checklist_Id from MST_Checklist where MST_WorkStation_Id = @WS and MST_Model_Id = @ETCodeId and M_BOM_Id = @TMCodeId and Item = @Parameter and IsActive =1 and IsDeleted = 0)
			BEGIN
				select 0 
			END
		else
			BEGIN
			set @SequenceNum = (SELECT max(SequenceNum) FROM MST_Checklist WHERE MST_WorkStation_Id = @WS and  M_BOM_Id = @TMCodeId and IsActive = 1 and IsDeleted = 0) + 1
			-- Conditional update based on the existence check
			if @SequenceNum is null
				set @SequenceNum = 1
				Insert Into MST_Checklist(MST_Area_Id, MST_Line_Id, MST_Model_Id, M_BOM_Id, Item, LowerLimit, UpperLimit, MST_WorkStation_Id, SequenceNum, CreatedBy, CreatedDate)
				values (@Area, @Line, @ETCodeId, @TMCodeId, @Parameter, @LowerLimit, @UpperLimit, @WS, @SequenceNum, @CreatedBy, GETDATE())
				select 1 as Result
			END
	END
else
	begin
		select 0 as Result
	end