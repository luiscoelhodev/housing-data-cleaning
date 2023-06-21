# Nashville Housing Data Cleaning Project

This personal project aims to perform a thorough cleaning of some housing data specific to Nashville. It involves leveraging SQL commands to clean and organize the dataset, ensuring data quality and accuracy. By applying various data cleaning techniques, this project provides reliable and well-structured data for further analysis and decision-making processes related to the Nashville housing market.

## Content

[1. Getting Started](#getting-started)  
&emsp;[1.1 Requirements](#requirements)  
[2. Download and Installation](#download-and-installation)  
[3. Data Source](#data-source)  
[4. License](#license)  

## Getting Started

The following instructions will help you get a copy of this project and execute the queries to observe the result sets they generate.

### Requirements

You need to have any DBMS (Database Management System) installed on your system that supports the standard SQL syntax and functions, such as MySQL, PostgreSQL, Microsoft SQL Server **(the one I used)**, Oracle, or others.

It's also recommended to have a Database Manager such as MySQL Workbench or Microsoft SQL Server Management Studio so you can work better with the queries and visualize their results.

## Download and Installation

1. You can clone this repository or simply download the .zip file by clicking on 'Code' -> 'Download ZIP' at <https://github.com/luiscoelhodev/housing-data-cleaning>.

2. Once you have all the files of this project, you can find the dataset in a file called 'Nashville-Housing-Data-for-Data-Cleaning.xlsx'. It can imported into a new database or an existing one so the queries can be executed against it.

3. Open your SQL DB Manager, create a new database or use an existing one to import the excel file into a table. The steps may vary depending on the DB manager you are using. Here is a general approach: In your DB manager, locate the option to import data from a file or external source ->
Select the Excel file and follow the prompts to specify the target table and mapping of columns ->
Verify that the data has been imported successfully by checking the table contents.

4. The queries I wrote for this project can be found in a file called 'cleaning-queries.sql'. You can open it directly to run them or create a new query window to copy/paste them into the editor.  

5. Execute the query you want to retrieve the desired results.  

**Note:** Please ensure you have a valid database connection established in your DB manager before executing the queries. Adjust the queries if needed based on the structure of the imported table.

## Data Source

The dataset I used for this project can be found in the root folder of this project, it is called 'Nashville-Housing-Data-for-Data-Cleaning.xlsx'.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
