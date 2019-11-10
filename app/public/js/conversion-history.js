const vm = new Vue({
    el: "#history_wrapper",
    data: function () {
        return {
            tableOptions: {
                size: 5,
                page: 1,
                total: 0
            },
            history_items: [],
            uiParams: {
                loading: false,
                displayError : false,
            }
        }
    },
    computed: {
        has_next: function () {
            return (this.tableOptions.total - (this.tableOptions.size * this.tableOptions.page)) > 0;
        }
    },
    methods: {
        handleSizeChange: function () {
            this.tableOptions.page = 1;
            this.load_content();
        },
        previous: function () {
            this.tableOptions.page -= 1;
            this.load_content();
        },
        next: function () {
            this.tableOptions.page += 1;
            this.load_content();
        },
        load_content: function () {
            let self = this;
            self.uiParams.loading = true;
            axios.post("/currency/history", self.tableOptions)
                .then(function (result) {
                    self.tableOptions.total = result.data.count;
                    self.history_items = result.data.rows;
                    self.uiParams.loading = false;
                }).catch(function (error) {
                if(self.uiParams.displayError !== true){
                    self.uiParams.displayError = true;
                    setTimeout(() => {
                        self.uiParams.displayError = false;
                    }, 2000)
                }
            })
        }
    },
    beforeMount: function () {
        this.load_content();
    }
})