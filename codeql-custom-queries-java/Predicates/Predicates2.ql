import java

string getANeighbor(string country) {
    country = "France" and result = "Belgium"
    or
    country = "France" and result = "Germany"
    or
    country = "Germany" and result = "Austria"
    or
    country = "Germany" and result = "Belgium"
    or
    country = "shahai" and  result = "beij"
    or
    country = getANeighbor(result)
}

select 
getANeighbor("beij") 
