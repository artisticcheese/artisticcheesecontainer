/****** Script for SelectTopNRows command from SSMS  ******/
create table Table01 (
	id int not null , 
	DataSetNum smallint , 
	data varchar(8000) ,
	constraint t01pk primary key clustered (id) with ( FILLFACTOR = 100, PAD_INDEX  = OFF )
) 

create table Table02 (
	id int not null , 
	DataSetNum smallint , 
	data varchar(8000) ,
	constraint t02pk primary key clustered (id) with ( FILLFACTOR = 100, PAD_INDEX  = OFF )
) 


DELETe from table02
DELETe from table01

Update statistics table02
Update statistics table01

declare	@RowLimit		bigint
,		@LoopNum		bigint
,		@sql			varchar(8000)

select	@RowLimit	=	2*64*8*3 -- 10 tables * 64 extents * 8 pages * 3 rows
,		@LoopNum	=	0

BEGIN TRANSACTION
while @LoopNum < @RowLimit begin

	-- Table = (@LoopNum/3%10)+1
	-- DataSet = (@LoopNum%3)+1
	if (@LoopNum%3)+1 in ( 1 , 3 )
		set @sql = 'insert Table'+right('0'+CONVERT(varchar(2),(@LoopNum/3%2)+1),2)+' ( id , DataSetNum , data ) values ( '+CONVERT(varchar(100),@LoopNum)+' , 1 , REPLICATE(''A'', 3000) )'
	if (@LoopNum%3)+1 = 2
		set @sql = 'insert Table'+right('0'+CONVERT(varchar(2),(@LoopNum/3%2)+1),2)+' ( id , DataSetNum , data ) values ( '+CONVERT(varchar(100),@LoopNum)+' , 2 , REPLICATE(''A'', 1000) )'
	
	--print @sql
	exec(@sql)

	set @LoopNum = @LoopNum + 1
end -- while @LoopNum < @RowLimit
COMMIT TRANSACTION



update	Table01
set		data = REPLICATE('B', 3000)
where	DataSetNum = 2 

update	Table01
set		data = REPLICATE('A', 3000)
where	DataSetNum = 1

update	Table02
set		data = REPLICATE('B', 3000)
where	DataSetNum = 2 

update	Table02
set		data = REPLICATE('A', 3000)
where	DataSetNum = 1


ALTER INDEX ALL ON Table02 REBUILD

SELECT COUNT(*) from DB1.dbo.Table01 where data like 'abc'
SELECT COUNT(*) from DB1.dbo.Table02 where data like 'abc'