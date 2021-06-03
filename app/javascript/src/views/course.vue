<template>
  <div>
    <h2 style="text-align: center;">課程管理系統</h2>
    <el-button
      type="primary"
      @click="dialog = true"
    >
      新增課程
    </el-button>

    <el-table
      :data="courses"
      style="width: 100%"
      :default-sort ="{prop: 'id', order: 'descending'}"
    >
      <el-table-column
        v-for="column in columns"
        :key="column.key"
        :label="column.text"
        :prop="column.key"
        :sortable="column.is_sortable"
      >
        <template slot-scope="scope">
          <template v-if="column.key === 'actions'">
            <el-button-group>
              <el-button
                @click="editItem(scope.row)"
                type="primary"
                size="small"
                icon="el-icon-edit"
              >
                編輯
              </el-button>
              <el-button
                @click="deleteItem(scope.row)"
                type="danger"
                size="small"
                icon="el-icon-delete"
              >
                刪除
              </el-button>
            </el-button-group>
          </template>
          <template v-else-if="column.key==='currency'">
            {{ currencyList.filter(e => scope.row[column.key] === e).join(',') }}
          </template>
          <template v-else-if="column.key==='category_id'">
            {{ categoryList.filter(e => scope.row[column.key] === e.id)
              .map(e => e.name).join(', ') }}
          </template>
          <template v-else-if="column.type==='boolean'">
            {{ scope.row[column.key] ? '是' : '否' }}
          </template>
          <template v-else>
            {{ scope.row[column.key] }}
          </template>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog 
      :visible.sync="dialog"
      :title="(isEdit? '編輯':'新增') + '課程'"
    >
      <el-form
        ref="dataForm"
        :model="editedItem"
        :rules="rules"
        label-position="left"
        label-width="30%"
        style="width: 90%; margin-left:50px;"
      >
        <template v-for="column in columns">
          <template v-if="column.can_edit">
            <el-form-item
              v-if="column.type==='boolean'"
              :key="column.key"
              :label="column.text"
              :prop="column.key">
              <el-checkbox
                v-model="editedItem[column.key]"
              />
            </el-form-item>
            <el-form-item
              v-else-if="column.key==='currency'"
              :key="column.key"
              :label="column.text"
              :prop="column.key"
            >
              <el-select
                v-model="editedItem[column.key]"
                class="filter-item"
                placeholder="請選擇"
                filterable
                clearable
              >
                <el-option
                  v-for="(value) in currencyList"
                  :key="value"
                  :label="value"
                  :value="value"
                />
              </el-select>
            </el-form-item>
            <el-form-item
              v-else-if="column.key==='category_id'"
              :key="column.key"
              :label="column.text"
              :prop="column.key"
            >
              <el-select
                v-model="editedItem[column.key]"
                class="filter-item"
                placeholder="請選擇"
                filterable
                clearable
              >
                <el-option
                  v-for="(value) in categoryList"
                  :key="value.id"
                  :label="value.name"
                  :value="value.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item 
              v-else
              :key="column.key" 
              :label="column.text" 
              :prop="column.key" 
              >
              <el-input
                v-model="editedItem[column.key]"
                :type="column.type"
                placeholder="請輸入"
              />
            </el-form-item>
          </template>
        </template>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog = false">
          取消
        </el-button>
        <el-button v-if="isEdit" @click="updateCourse()" type="primary">
          確定修改
        </el-button>
        <el-button v-else @click="createCourse()" type="primary">
          確定新增
        </el-button>
      </div>
    </el-dialog>

    <el-dialog
      title="警告"
      :visible.sync="dialogDelete"
      width="30%">
      <span>確定要刪除嗎？</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="closeDelete">取消</el-button>
        <el-button type="primary" @click="deleteItemConfirm">確定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import courseFunc from '../services/course'

  export default {
    data: () => ({
      dialog: false,
      dialogDelete: false,
      columns: [
        {
          text: '課程主題',
          key: 'name',
          is_sortable: false,
          can_edit: true,
          type: 'text',
          is_required: true,
        },
        { 
          text: '價格', 
          key: 'price',
          can_edit: true,
          type: 'number',
          is_required: true,
        },
        {
          text: '幣別',
          key: 'currency',
          can_edit: true,
          type: 'dropdown',
          is_required: true,
        },
        {
          text: '類型',
          key: 'category_id',
          can_edit: true,
          type: 'dropdown',
          is_required: true,
        },
        {
          text: '上架',
          key: 'for_sale',
          can_edit: true,
          type: 'boolean',
        },
        {
          text: 'URL',
          key: 'url',
          can_edit: true,
          type: 'text',
          is_required: true,
        },
        {
          text: '描述',
          key: 'description',
          can_edit: true,
          type: 'textarea',
        },
        {
          text: '效期（天）',
          key: 'availability_period',
          is_required: true,
          can_edit: true,
          type: 'number',
        },
        {
          text: 'Actions',
          key: 'actions',
          is_sortable: false,
        },
      ],
      courses: [],
      editedIndex: -1,
      editedId: 0,
      editedItem: {
        name: '',
        price: null,
        currency: 'TWD',
        category_id: null,
        for_sale: false,
        url: '',
        description: '',
        availability_period: null,
      },
      defaultItem: {
        name: '',
        price: null,
        currency: 'TWD',
        category_id: null,
        for_sale: false,
        url: '',
        description: '',
        availability_period: null,
      },
      categoryList: [],
      currencyList: [],
      rules: {},
    }),
    computed: {
      isEdit () {
        return this.editedIndex !== -1
      },
    },

    watch: {
      dialog (val) {
        val || this.close()
      },
      dialogDelete (val) {
        val || this.closeDelete()
      },
    },

    created () {
      this.setTableData()
      this.getCategoryList()
      this.getCurrencyList()
      this.createRules()
    },

    methods: {
      setTableData() {
        return courseFunc.getCourseList().then(response => {
            // gem grape bug: decimal number becomes string in frontend
            this.courses = response.data.map((course) => {
              course.price = parseFloat(course.price)
              return course
            });
          })
          .catch(e => {
            alert(e.response.data.error.message)
          });
      },
      getCategoryList() {
        courseFunc.getCategoryList().then(response => {
          this.categoryList = response.data
        })
      },
      getCurrencyList() {
        courseFunc.getCurrencyList().then(response => {
          this.currencyList = response.data
        })
      },
      editItem (item) {
        this.editedIndex = this.courses.indexOf(item)
        this.editedId = item.id
        this.editedItem = Object.assign({}, item)
        this.dialog = true
      },
      deleteItem (item) {
        this.editedIndex = this.courses.indexOf(item)
        this.editedId = item.id
        this.editedItem = Object.assign({}, item)
        this.dialogDelete = true
      },
      deleteItemConfirm () {
        this.courses.splice(this.editedIndex, 1)

        courseFunc.deleteCourse(this.editedId).then(response => {
          })
          .catch(e => {
            alert(e.response.data.error.message)
          });

        this.closeDelete()
      },
      close () {
        this.dialog = false
        this.$nextTick(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        })
      },
      closeDelete () {
        this.dialogDelete = false
        this.$nextTick(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        })
      },
      async createCourse() {
        const valid = await this.$refs['dataForm'].validate()
        if(!valid) { return }
        courseFunc.createCourse(this.editedItem).then(response => {
            this.setTableData();
          })
          .catch(e => {
            alert(e.response.data.error.message)
          });

        this.close()
      },
      async updateCourse() {
        const valid = await this.$refs['dataForm'].validate()
        if(!valid) { return }
        courseFunc.editCourse(this.editedId, this.editedItem).then(response => {
            this.setTableData();
          })
          .catch(e => {
            alert(e.response.data.error.message)
          });

        this.close()
      },
      createRules() {
        const rules = {}
        for (const column of this.columns) {
          rules[column.key] = []
          const rule = {}
          if (column.type === 'dropdown' && column.is_required) {
            rule.required = true
            rule.message = `${column.text} is required`
            rule.trigger = 'change'
            rules[column.key].push(rule)
          } else if (column.type === 'number' && column.is_required) {
            rule.required = true
            rule.trigger = 'blur'
            rule.validator = (rule, value, callback) => {
              if (value === null) {
                callback(new Error(`${column.text} is required`))
              } else if (isNaN(Number(value)) || Number(value) === 0) {
                callback(new Error('請輸入大於 0 的數字'))
              } else {
                callback()
              }
            }
            rules[column.key].push(rule)
          } else if (column.key === 'url' && column.is_required) {
            rule.required = true
            rule.trigger = 'blur'
            rule.validator = (rule, value, callback) => {
              const reg = /(www|http:|https:)+\/\/[^\s]+/
              if (value === null) {
                callback(new Error(`${column.text} is required`))
              } else if (!reg.test(value)) {
                callback(new Error('請輸入有效的網址'))
              } else {
                callback()
              }
            }
            rules[column.key].push(rule)
          } else if (column.is_required) {
            rule.required = true
            rule.message = `${column.text} is required`
            rule.trigger = 'blur'
            rules[column.key].push(rule)
          }
        }
        this.rules = rules
      },
    },
  }
</script>
