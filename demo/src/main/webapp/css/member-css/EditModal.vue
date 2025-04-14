<template>
  <div class="modal fade" id="editMemberModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">회원정보 수정</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="submitForm">
            <!-- 입력 필드들 -->
            <div class="mb-3">
              <label class="form-label">닉네임</label>
              <input type="text" class="form-control" v-model="localData.nickname" required>
            </div>
            <!-- 주소 검색 필드 -->
            <div class="mb-3">
              <label class="form-label">주소</label>
              <div class="input-group">
                <input type="text" class="form-control" v-model="localData.address" id="memberAddress" readonly>
                <button type="button" class="btn btn-outline-secondary" @click="searchAddress">주소 검색</button>
              </div>
              <input type="text" class="form-control mt-2" v-model="localData.addressDetail" placeholder="상세주소">
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
          <button type="button" class="btn btn-primary" @click="submitForm">저장하기</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    memberData: Object // 부모로부터 받은 회원정보
  },
  data() {
    return {
      localData: {
        nickname: '',
        address: '',
        addressDetail: ''
      },
      modalInstance: null
    };
  },
  methods: {
    initModal() {
      this.modalInstance = new bootstrap.Modal(
        document.getElementById('editMemberModal'),
        { backdrop: 'static' }
      );
    },
    searchAddress() {
      new daum.Postcode({
        oncomplete: (data) => {
          this.localData.address = data.roadAddress;
        }
      }).open();
    },
    submitForm() {
      this.$emit('submit', {
        ...this.localData,
        fullAddress: `${this.localData.address} ${this.localData.addressDetail}`
      });
      this.modalInstance.hide();
    }
  },
  watch: {
    memberData: {
      immediate: true,
      handler(newVal) {
        if (newVal) {
          // 주소 분리 로직
          const addrParts = (newVal.address || '').split(' ');
          this.localData = {
            nickname: newVal.nickname || '',
            address: addrParts.slice(0, -1).join(' '),
            addressDetail: addrParts[addrParts.length - 1] || ''
          };
        }
      }
    }
  },
  mounted() {
    this.initModal();
  },
  beforeUnmount() {
    if (this.modalInstance) {
      this.modalInstance.dispose();
    }
  }
};
</script>