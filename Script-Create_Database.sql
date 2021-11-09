use master
go

create database LojaSuco on primary
(
name = N'LojaSuco',
filename = N'B:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LojaSuco_dtb',
size = 1MB,
maxsize = 25MB,
filegrowth = 524KB
)
LOG on 
(
name= N'LojaSuco_Log',
filename = N'B:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LojaSuco_log',
size = 524KB,
maxsize = 5MB,
filegrowth = 256KB
)