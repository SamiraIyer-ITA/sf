export function getQueryParameters() {
	var params = {};
	var search = location.search.substring(1);
	if (search) {
		params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
			return key === "" ? value : decodeURIComponent(value)
		});
	}
	return params;
}