import csv
import re
#create 3 dictionaries where the values matter the most
list_of_comps = {}
frequency_values = {}
Final_dict = {} 

#this script will require that you take a computer list from snow, compare those computers to the computer listed in bomgar and use a vlookup in excel to make a sheet. 
#essentially you want a column of machines in SNOW but not in Bomgar and who they are assigned to. I recommend filtering out all computers not assigned to someone. 
#column headers need to be 'Comps_notin_snow' and 'assigned_to' for this to work. 

#step 1 create a dictionary w/ values that I want. 

file_path = 'C:\\Users\\padgenoa\\Documents\\Comp_analysis_ivanti.csv'


with open(file_path) as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        if row['Comps_notin_snow'] == '':
            continue
        else:
            #if in an AD distinguished name format, filter otherwise put the raw string in...raw 
            match_name = re.match(r'^CN=([A-Za-z0-9 \"()_.-]+),', row['assigned_to'])
            if match_name == None:
                list_of_comps[row['Comps_notin_snow']] = row['assigned_to']
            else:
                list_of_comps[row['Comps_notin_snow']] = str(match_name.group(1))

#check frequency of those values 
for value in list_of_comps.values(): 
    if value not in frequency_values.keys(): 
        frequency_values[value] = 0
    frequency_values[value] += 1 

#create another dictionary with just people who only appear once removing servers and such. 
for key,value in frequency_values.items():
    if value > 1:
        continue
    else:
        for key_org,value_org in list_of_comps.items():
            if key == value_org:
                Final_dict[key_org] = key

#create a csv with those values. 
with open('c:/Users/padgenoa/Documents/export_ben_comps.csv', 'w+',newline='') as file:
    Fieldnames = ['computer','assigned_to']
    writer = csv.DictWriter(file, fieldnames=Fieldnames)
    writer.writeheader()
    for key,value in Final_dict.items():
        writer.writerow({'computer' : key , 'assigned_to' : value })