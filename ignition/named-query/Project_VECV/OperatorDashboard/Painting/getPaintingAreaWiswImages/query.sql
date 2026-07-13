select * from MST_PaintingTypeConfiguration where IsActive=1 and  IsDeleted=0 and MST_Area_Id= :MST_Area_Id
and MST_PaintingType_Id = :MST_PaintingType_Id 
order by CreatedDate