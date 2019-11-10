// Vue pipe to format date using moment js

Vue.filter('formatDate', function(value) {
    if (value) {
        return moment(String(value)).format('MM/DD/YYYY hh:mm:ss');
    }
});