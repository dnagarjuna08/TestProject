Select M.ModelName,V.POKAYOKE_GNS_SWITCH_CHECK, V.POKAYOKE_PTO_PHYSICAL_CHECK
from MST_FunctionalSelection V
inner join M_BOM B on B.M_BOM_Id=V.M_BOM_Id
inner join MST_Model M on M.MST_Model_Id=V.MST_Model_Id
where V.MST_Area_Id= :MST_Area_Id  and V.MST_Line_id= :MST_Line_id and B.M_BOMNumber= :M_BOMNumber and V.IsActive=1 and V.IsDeleted=0 
and V.MST_WorkStation_Id= :MST_WorkStation_Id
