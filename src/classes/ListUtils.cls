Global Class ListUtils{
    Global static SelectOption[] sortSelectOptions(List<SelectOption> lst){
        SelectOption[] output = new SelectOption[]{};
        Set<String> keySet = new Set<String>();
        for(SelectOption item : lst){
            keySet.add(item.getLabel());
        }
        String[] keys = new list<string>(keySet);
        keys.sort();
        for(String key : keys){
            for(SelectOption item : lst){
                if(key == item.getLabel()){
                    output.add(item);
                }
            }
        }
        return output;
    }
}