#!/bin/bash
# 11.12.2023 03:06:08 Basty-devel
# This script links the output of sublist3r.py with the input of hakrawler.go for a deeper and broader crawl.
# It was tested on a Raspberry Pi 400; ARMv7 64 bit 1.7GHz quadcore CPU; 4 GB RAM; Raspberry OS Debian 12 Bookworm.
# It is not resource-hungry, and no API registration is needed.
# For educational purpose and scoped pentesting only!

# Check if sublist3r is installed
if ! command -v sublist3r &> /dev/null; then
    echo "Sublist3r is not installed. Please install it using 'sudo apt install sublist3r'."
    exit 1
fi

# Check if hakrawler is installed
if ! command -v hakrawler &> /dev/null; then
    echo "Hakrawler is not installed. Please install it following the instructions for your system."
	echo "git clone https://github.com/hakluke/hakrawler
cd hakrawler
sudo docker build -t hakluke/hakrawler"
    exit 1
fi

# User Input
read -p "Enter the target domain or IP address: " target_domain
read -p "Enter the absolute path to the output file: " output_file_path

# Subdomain Enumeration
echo "Running sublist3r for subdomain enumeration..."
subdomains=$(python3 sublist3r.py -d $target_domain -v -b -p 21,22,53,80,443 -o $output_file_path)

# Subdomain Scanning
declare -a subdomains2

echo "Running hakrawler for subdomain scanning..."
for subdomain in $subdomains; do
    subdomains2+=( $(cat $subdomain | docker run --rm -i hakluke/hakrawler -subs -d 4 -proxy http://127.0.0.1:8080 -h 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)' -s -u -w) )
done

# Output and Reporting
echo "Subdomains:"
echo "${subdomains[@]}" > subdomains.txt
echo "Results saved to subdomains.txt."
echo "Happy Testing!"

# defining arrays to store subs+paxloads and payloads
declare -a payloads=(/home/$User/Desktop/x55.txt)  
declare -a url_p

echo "adding payloads to subdomains..."
for payload in "${payloads[@]}"; do
    for subdomain2 in "${subdomains2[@]}"; do
        url_p+=( $(cat $subdomain2 | sed "/=/=$payload/") )
    done
done

# Print results
echo "Results with payloads:"
for element in "${url_p[@]}"; do
    echo $element > url_pay.txt
done

echo """
                                           @@@@@@@@@@@@@@                                           
                                       @@@@@@@@@@@@@@@@@@@@@@                                       
                                    @@@@@@@%#*********#%@@@@@@@@                                    
                                  @@@@@@%*****************#%@@@@@@                                  
                                 @@@@@#**********************#@@@@@                                 
                               @@@@@#**************************#@@@@@                               
                             @@@@@%******************************%@@@@@                             
                            @@@@@*********************************#@@@@@                            
                           @@@@%************************************@@@@@                           
                          @@@@%**************************************%@@@@                          
                         @@@@%***************###%%%%###***************%@@@@                         
                        @@@@%*********#%@@@@@@@@@@@@@@@@@@@@%##********%@@@@                        
                       @@@@%*******%@@@@@@@%#*+++==+++*#%@@@@@@@%#******%@@@@                       
                       @@@@*****#@@@@@%+-::::::::::::::::::-+%@@@@@%****#@@@@                       
                      @@@@#***%@@@@#-::::::::::::::::::::::::::-#@@@@%#**%@@@@                      
                      @@@@**%@@@%=.:::::::::::::::::::::::::::::::=%@@@%#*@@@@                      
                     @@@@##@@@@-....:::::::::::::--:::::::::::::::::=@@@%*#@@@@                     
                     @@@@#@@@#......:::::::::+@@@@@@@@*::::::::::::::%@@%**@@@@                     
                     @@@@@@@%-......:::::::-%@@@#**#@@@%-::::::::::::%@@%#*%@@@                     
                    @@@@@@@%#-......:::::::%@@#::::::#@@%::::::::::::%@@%###@@@@                    
                    @@@@@@%##-......:::::::@@@-::::::=@@@::::::::::::%@@%###@@@@                    
                    @@@@@@###-......:::::::-+-:::::::#@@%::::::::::::%@@%###@@@@                    
                    @@@@@####-......:::::::::::::::*@@@%-::::::::::::%@@%###@@@@                    
                    @@@@%####=.......::::::::::::+@@@@+::::::::::::::@@@%###@@@@                    
                    @@@@%###@@@-.....:::::::::::+@@@+:::::::::::::::=@@@###%@@@@                    
                     @@@@###@@@#......::::::::::*@@#::::::::::::::::#@@@###@@@@                     
                     @@@@%###@@@+......:::::::::-*#-:::::::::::::::+@@@###%@@@@                     
                      @@@@###%@@@=.....:::::::::::::::::::::::::::=@@@%###@@@@                      
                      @@@@@###%@@@=......:::::::+@@+:::::::::::::+@@@%###%@@@@                      
                       @@@@%###%@@@#:.....::::::+@@+::::::::::::%@@@%###%@@@@                       
                        @@@@%####@@@@*:....:::::::::::::::::::*@@@@%###%@@@@                        
                         @@@@@####%@@@@%=..::::::::::::::::=%@@@@%####%@@@@                         
                          @@@@@%####%@@@@@@#=-::::::::-=#@@@@@@%#####@@@@@                          
                           @@@@@@%#####%@@@@@@@@@@@@@@@@@@@@%######@@@@@@                           
                             @@@@@@%#######%%@@@@@@@@@@%%########@@@@@@                             
                               @@@@@@@########################%@@@@@@                               
                                 @@@@@@@@%%#################@@@@@@@                                 
                                    #%@@@@@@@@@@@@@@@@%#####%@@@@@@@@                               
                          @@@@@@%********%@@@@@@@@@@@@%*******#@@@@@@@@@@@                          
                      @@@@@@@@@%****************####**************#%@@@@@@@@@@                      
                   @@@@@@@%#*******************************************##%@@@@@@@                   
                  @@@@@#********************%@@%****#@@%********************%@@@@@                  
                 @@@@%*********************#@@@%****%@@@#*********************%@@@@                 
                @@@@#**********************#@@@#*****@@@%**********************%@@@@                
                @@@%**********************#@@@%******#@@@%*********************#@@@@                
                @@@%*********************%@@@%********#@@@%*********************%@@@@               
                @@@%*********************%@@%**********#@@@#********************%@@@@               
                @@@%************************************************************%@@@@               
                @@@%************************************************************%@@@@               
                @@@%************************************************************%@@@@               
                @@@%************************************************************%@@@@               
                @@@%************************************************************%@@@@               
                @@@%************************************************************%@@@@               
                @@@%************************************************************%@@@@               
                @@@@                                                            @@@@ """
