program define geocodenom
    // Check if the required arguments are provided
    syntax varlist(min=1 max=1), save(string)
    
    // Extract the variable name containing addresses
    local address_var `1'
    
    // Create new variables for latitude and longitude
    gen double latitude = .
    gen double longitude = .
    
    // Loop over each observation
    forvalues i = 1 / `=_N' {
        // Get the address for the current observation
        local address : word `i' of `address_var'
        
        // URL encode the address
        local address_urlencoded = ustrregexra("`address'", " ", "+")
        
        // Sleep for 1 second to avoid hitting the API rate limit
        sleep 1000
        
        // Construct the API URL
        local url = "https://nominatim.openstreetmap.org/search?q=`address_urlencoded'&format=json&limit=1"
        
        // Use curl to fetch the JSON response from the API
        tempfile response
        shell curl -s -o "`response'" "`url'"
        
        // Check if the response file exists
        if !fileexists("`response'") {
            di as error "Error: Response file not found."
            continue
        }
        
        // Parse the JSON response to extract latitude and longitude
        file open myfile using "`response'", read text
        file read myfile line
        file close myfile
        
        // Extract latitude and longitude from JSON response
        local lat_start = strpos(`"`line'"', `"lat":'') + 6
        local lat_end = strpos(substr(`"`line'"', `lat_start'), `"') + `lat_start' - 1
        local lon_start = strpos(`"`line'"', `"lon":'') + 6
        local lon_end = strpos(substr(`"`line'"', `lon_start'), `"') + `lon_start' - 1
        local latitude = substr(`"`line'"', `lat_start', `lat_end' - `lat_start')
        local longitude = substr(`"`line'"', `lon_start', `lon_end' - `lon_start')
        
        // Update the dataset with the extracted latitude and longitude
        replace latitude = real("`latitude'") in `i'
        replace longitude = real("`longitude'") in `i'
    }
    
    // Save the dataset with geocoded data
    save "`save'", replace
end





