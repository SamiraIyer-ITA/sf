public without sharing class CSVIterator implements Iterator<String>, Iterable<String> {
   private String m_CSVData;
   private String m_introValue;
   public CSVIterator(String fileData, String introValue) {
      m_CSVData = fileData;
      m_introValue = introValue; 
   }
   public Boolean hasNext() {
      return (m_CSVData.length() > 1 && m_CSVData.indexOf(m_introValue) > -1) ? true : false;
   }
   public String next() {
      system.debug(m_CSVData);
      system.debug(m_CSVData.indexOf(m_introValue));
      string row = m_CSVData.subString(0, m_CSVData.indexOf(m_introValue));
      m_CSVData = m_CSVData.subString(m_CSVData.indexOf(m_introValue) + m_introValue.length(),m_CSVData.length());
      return row;
   }
   public Iterator<String> Iterator() {
      return this;   
   }
}