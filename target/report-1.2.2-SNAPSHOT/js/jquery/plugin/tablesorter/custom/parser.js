$.tablesorter.addParser(
{
    // set a unique id
    id: 'formattedNumbers',
    is: function(s, table)
    {
        // return false so this parser is not auto detected
		var c = table.config;
		return $.tablesorter.isDigit(s.replace(/,/g, ""), c);
    },
    format: function(s)
    {
        // format your data for normalization
        //return s.replace(/,/g, ''); //removes comma separator from formatted numbers
        return jQuery.tablesorter.formatFloat(s.replace(/,/g, ""));
    },
    // set type, either numeric or text
    type: 'numeric'
});
