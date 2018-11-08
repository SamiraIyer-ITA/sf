public class NewToMarketDataAvailabilityController {
    public String csvFile {get;set;}
    public NewToMarketDataAvailabilityController() {
        csvFile = '';
        StaticResource defaultResource = [Select Body From StaticResource WHERE Name =: 'NTMDataAvailabilityCSV'];
        blob tempB = defaultResource.Body;
        String contentFile = tempB.toString();
        String[] filelines = contentFile.split('\n');
        String csvLines = '';
        for (Integer i=0;i<filelines.size();i++)
        {
            String csvLine = '<tr>';
            String[] inputvalues = filelines[i].split(',');
            if(inputvalues[0].contains('"')) { //special care to parse countries with commas in the name
                inputvalues[0] = inputvalues[0].remove('"') + ',' + inputvalues[1].remove('"');
                inputvalues.remove(1);
            }
            if(i==0) { //set up table header
                for(String s : inputvalues) {
                    csvLine += '<th>'+s+'</th>';
                }
            } else {
                for(String s : inputvalues) { //set up table data
                    csvLine += '<td>'+s+'</td>';
                }
            }
            csvLine += '</tr>';
            csvLines += csvLine;
        }
        csvFile = '<table>'+csvLines+'</table>';
    }
}