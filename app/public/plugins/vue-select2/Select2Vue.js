Vue.component('select2',
    {
        props: {
            name: {
                default: ''
            },
            value: {
                default: function () {
                    return null;
                }
            },
            options: {
                default: function () {
                    return [];
                }
            },
            multiple: {
                default: false
            },
            templating: {
                default: false
            }
        },
        template:
            ` <select  class="form-control select2" style="width: 100%;" tabindex="-1" aria-hidden="true" :multiple="multiple" >
                            <slot>
                            </slot>
                        </select>`,
        mounted: function () {
            var vm = this
            // Test If there is templating 
            let initOpt = {
                data: this.options,
                tags: "true",
            }
            if (this.templating) {
                initOpt.templateResult = vm.customDisplay;
            }
            $(this.$el)
                // init select2
                .select2(initOpt)
                .val(this.value)
                .trigger('change')
                // emit event on change.
                .on('change',
                    function () {
                        vm.$emit('input', $(this).val())

                        if (vm.multiple) {
                            vm.$emit('change', this.value)
                        } else {
                            vm.$emit('v-s2-change', this.value)
                        }
                    });
        },
        watch: {
            value: function (value) {
                // update value
                if (this.multiple) {
                    if ($(this.$el).val() != null) {
                        if ([...value].sort().join(",") !== [...$(this.$el).val()].sort().join(","))
                            $(this.$el).val(value).trigger('change');
                    }
                } else {
                    $(this.$el).val(value).trigger('change');
                }
            },
            options: function (options) {
                // update options
                let self = this;
                $(this.$el).empty().select2({ data: options })
            }
        },
        methods: {
            customDisplay: function (state) {
                if (!state.id) {
                    return state.text;
                }
                var $state = $(
                    '<span><img src="' + state.image + '" class="v-select2-template" /> ' + state.text + '</span>'
                );
                return $state;
            }
        },
        destroyed: function () {
            $(this.$el).off().select2('destroy')
        }
    })