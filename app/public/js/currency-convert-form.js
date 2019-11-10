var vm = new Vue({
    el: "#convert_wrapper",
    data: function () {
        return {
            uiParams: {
                loading: false,
                message: "",
                success: false,
                showAlert: false
            },
            options: {
                all_options: [
                    {
                        value: "EUR",
                        text: "EUR"
                    },
                    {
                        value: "USD",
                        text: "USD"
                    },
                    {
                        value: "CHF",
                        text: "CHF"
                    }
                ],
                from_options: [],
                to_options: []
            },
            currency_convert: {
                "from": null,
                "to": null,
                "result": 0,
                "value": 0
            }
        }
    },
    methods: {
        change_from_handler: function () {
            // get only options that should be displayed
            const current_selected = this.currency_convert.from;
            if (current_selected === "EUR") {
                // display all except EURO
                this.options.to_options = this.options.all_options.filter(opt => opt.value !== "EUR");
            } else {
                // display only EUR
                this.options.to_options = this.options.all_options.filter(opt => opt.value === "EUR");
            }
            const self = this;
            const exist = this.options.to_options.findIndex(item => item.value === self.currency_convert.to) !== -1;
            if (!exist){
                this.currency_convert.to = null;
            }
        },
        switch_currency: function ($event) {
            $event.preventDefault();
            this.options.to_options = this.options.from_options;
            const intermediate_value = this.currency_convert.to;
            this.currency_convert.to = this.currency_convert.from;
            this.currency_convert.from = intermediate_value;
            this.change_from_handler();
        },
        toggleAlert: function (message, status) {
            this.uiParams.success = status;
            this.uiParams.message = message;
            if (this.uiParams.showAlert !== true){
                this.uiParams.showAlert = true;
                let self = this;
                // in anonymous handlers this object is not the caller
                setTimeout(() => {
                    self.uiParams.message = "";
                    self.uiParams.success = false;
                    self.uiParams.showAlert = false;
                }, 2000)
            }
        },
        validate: function () {
            if (this.currency_convert.from == null) {
                this.toggleAlert("Choose a source currency !", false);
                return false;
            }
            if (this.currency_convert.to == null) {
                this.toggleAlert("Choose a target currency !", false);
                return false;
            }
            if (this.currency_convert.value <= 0) {
                this.toggleAlert("specify a positive amount!", false);
                return false;
            }
            return true;
        },
        convert_currency: function () {
            if (this.validate()) {

                let self = this;
                self.uiParams.loading = true;
                axios.post("/currency/convert", self.currency_convert)
                    .then(function (result) {
                        self.toggleAlert("Conversion done with success !", result.data.success);
                        self.currency_convert.result = result.data.msg;
                        self.uiParams.loading = false;
                    }).catch(function (error) {
                    self.uiParams.loading = false;
                    self.toggleAlert(error.response.data.msg, false);
                })
            }
        }
    },
    beforeMount: function () {
        this.options.from_options = this.options.all_options;
        this.options.to_options = this.options.all_options;
    }
})