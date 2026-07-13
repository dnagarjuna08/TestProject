Select O.MST_OPCode_Id, O.OPCode, D.OPDefinition,O.AttributeText,O.ImagePath from MST_OPCode O
inner join MST_OPDefinition D on D.MST_OPDefinition_Id= O.MST_OPDefinition_Id
where O.IsDeleted=0