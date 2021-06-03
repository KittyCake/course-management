<template>
  <div>
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
        },
        { 
          text: '價格', 
          key: 'price',
          can_edit: true,
          type: 'number',
        },
        {
          text: '幣別',
          key: 'currency',
          can_edit: true,
          type: 'dropdown',
        },
        {
          text: '類型',
          key: 'category_id',
          can_edit: true,
          type: 'dropdown',
        },
        {
          text: '上下架',
          key: 'for_sale',
          can_edit: true,
          type: 'boolean',
        },
        {
          text: 'URL',
          key: 'url',
          can_edit: true,
          type: 'text',
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
        price: 0,
        currency: 'TWD',
        category_id: null,
        for_sale: false,
        url: '',
        description: '',
        availability_period: 0,
      },
      defaultItem: {
        name: '',
        price: 0,
        currency: 'TWD',
        category_id: null,
        for_sale: false,
        url: '',
        description: '',
        availability_period: 0,
      },
      categoryList: [],
      currencyList: [],
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
      this.initialize()
      this.getCategoryList()
      this.getCurrencyList()
    },

    methods: {
      initialize () {
        return courseFunc.getCourseList().then(response => {
            // gem grape bug: decimal number becomes string in frontend
            this.courses = response.data.map((course) => {
              course.price = parseFloat(course.price)
              return course
            });
          })
          .catch(e => {
            console.log(e);
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
            console.log(response.data);
          })
          .catch(e => {
            console.log(e);
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
      createCourse() {
        this.courses.push(this.editedItem)

        courseFunc.createCourse(newCourse).then(response => {
            console.log(response.data);
          })
          .catch(e => {
            console.log(e);
          });

        this.close()
      },
      updateCourse() {
        Object.assign(this.courses[this.editedIndex], this.editedItem)

        courseFunc.editCourse(this.editedId, this.editedItem).then(response => {
            console.log(response.data);
          })
          .catch(e => {
            console.log(e);
          });

        this.close()
      },
    },
  }
</script>