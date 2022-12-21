create table tblEmployeeAudit(ID INT,AuditData nvarchar(100))
select * from tblEmployeeAudit
Select * from tblEmployee 

delete from tblEmployee where ID =10

set identity_insert tblEmployeeAudit ON 

alter trigger tr_tblEmployeeAudit_ForInsert on tblEmployee
for insert
as 
begin 
     
	 declare @ID int
	 select @ID=ID from inserted

	 insert into tblEmployeeAudit values(1,'New Employee with ID ='+cast(@ID AS nvarchar(20))+'is added at' +cast(GETDATE() AS nvarchar(20))) 

END



insert into tblEmployee values(12,'x','Male',3500,1)



create trigger tr_tblEmployeeAudit_ForDelete on tblEmployee
for delete
as 
begin 
     
	 declare @ID int
	 select @ID=ID from deleted

	 insert into tblEmployeeAudit values(1,'New Employee with ID ='+cast(@ID AS nvarchar(20))+'is deleted at' +cast(GETDATE() AS nvarchar(20))) 

END

delete from tblEmployee where ID =12


ALTER trigger tr_tblEmployeeAudit_ForUpdate on tblEmployee
for Update
as 
begin 
     Declare @ID int
	 Declare @OldName nvarchar(20),@NewName nvarchar(20)
	 Declare @OldGender nvarchar (20),@NewGender nvarchar(20)
	 Declare @OldSalary int,@NewSalary int
	 Declare @OldDeptID int,@NewDeptID int
	 Declare @AuditString nvarchar(1000)

	 select * into #Temptable from inserted

	 while (Exists(Select ID from #Temptable))
	 Begin
	       set @AuditString=''
		   select Top 1 @ID=ID,@NewName=Name,@NewGender=Gender,@NewSalary=Salary,@NewDeptID=DepartmentID FROM #Temptable

		   select @OldName=Name,@OldGender=Gender,@OldSalary=Salary,@OldDeptID=DepartmentID FROM deleted where ID=@ID

		   set @AuditString ='Employee with ID=' + cast(@ID as nvarchar(10)) + 'cahnged' 
		   if (@OldName <> @NewName)
		          set @AuditString=@AuditString + 'Name from' + @OldName +'to'+@NewName

		   if (@OldGender <> @NewGender)
		          set @AuditString=@AuditString + 'Name from' + @OldGender +'to'+@NewGender

		   if (@OldSalary <> @NewSalary)
		          set @AuditString=@AuditString + 'Name from' + @OldSalary +'to'+@NewSalary

		   if (@OldDeptID <> @NewDeptID)
		          set @AuditString=@AuditString + 'Name from' + @OldDeptID +'to'+@NewDeptID

			insert into tblEmployeeAudit values (2,@AuditString)
			Delete from #Temptable where ID=@ID
	END
END

END

update tblEmployee set Name='Tom' ,Gender ='Male' where ID in (1,2)
