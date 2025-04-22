<!-- /redirectPost.jsp -->
<form id="postRedirectForm" method="post" action="/board/detail">
    <input type="hidden" name="bno" value="${bno}">
</form>
<script>
    document.getElementById('postRedirectForm').submit();
</script>