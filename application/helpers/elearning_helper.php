<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Method untuk ngecek instal sudah berhasil atau berlum
 * @return true kalo sudah berhasil
 */
function install_success()
{
    $db_file = APPPATH . 'config/database.php';
    if (!is_file($db_file)) {
        throw new Exception(get_alert('error', 'File database.php in application/config/ not exists'));
    }

    # cek pengaturan database
    include APPPATH . 'config/database.php';

    $link = @mysqli_connect($db['default']['hostname'], $db['default']['username'], $db['default']['password']);
    if (!$link) {
        throw new Exception(get_alert('error', 'Failed to connect to the server: ' . mysqli_connect_error()));
    }
    elseif (!@mysqli_select_db($link, $db['default']['database'])) {
        throw new Exception(get_alert('error', 'Failed to connect to the database: ' . mysqli_error($link)));
    }

    $CI =& get_instance();
    $CI->load->database();

    if ($CI->db->table_exists('pengaturan')) {
        # cek record install-success
        $success = get_pengaturan('install-success', 'value');
        if (empty($success)) {
            return false;
        }
    } else {
        return false;
    }

    return true;
}

/**
 * Method untuk deklarasi array default yang akan di parser dan di berikan ke view
 *
 * @param  array  $add_item
 * @return array
 */
function default_parser_item($add_item = array())
{
    $CI =& get_instance();

    $url_referrer = '';
    if ($CI->agent->is_referral()) {
        $url_referrer = $CI->agent->referrer();
    } else {
        # kalo kosong diisi dengan segment
        $url_referrer = site_url($CI->uri->segment(1));
    }

    $return = array(
        'base_url'          => base_url(),
        'site_url'          => site_url(),
        'favicon_url'       => base_url('assets/images/favicon.ico'),
        'copyright_setup'   => 'Copyright &copy; 2016 - ' . date('Y') . ' <a href="#">SMK Islam SBM</a>',
        'current_url'       => current_url(),
        'logo_url_small'    => get_logo_url(),
        'logo_url_medium'   => get_logo_url('medium'),
        'logo_url_large'    => get_logo_url('large'),
        'base_url_theme'    => base_url_theme().'/',
        'site_name_default' => 'e-Learning system',
        'comp_css'          => '',
        'comp_js'           => '',
        'url_referrer'      => $url_referrer,
        'elapsed_time'      => $CI->benchmark->elapsed_time(),
    );

    # cek proses install tidak
    if ($CI->uri->segment(1) != 'setup') {
        $return['copyright'] = 'Copyright &copy; 2016 - ' . date('Y') . ' ' . get_pengaturan('nama-sekolah', 'value').' by  <a href="#">SMK Islam SBM</a>';
        $return['site_name'] = 'E-Learning '.get_pengaturan('nama-sekolah', 'value');
        $return['version']   = '<a href="#">versi ' . get_pengaturan('versi', 'value') . '</a>';
    }

    if (!empty($add_item) AND is_array($add_item)) {
        $return = array_merge($return, $add_item);
    }
    return $return;
}

/**
 * Method untuk load css komponent tambahan
 *
 * @param  array  $target_href
 * @return string
 */
function load_comp_css($target_href = array())
{
    $return = '';
    foreach ($target_href as $value) {
        $return .= '<link type="text/css" href="'.$value.'" rel="stylesheet">'.PHP_EOL;
    }
    return $return;
}

/**
 * Method untuk load js komponent tambahan
 *
 * @param  array  $target_src
 * @return string
 */
function load_comp_js($target_src = array())
{
    $return = '';
    foreach ($target_src as $value) {
        $return .= '<script src="'.$value.'" type="text/javascript"></script>'.PHP_EOL;
    }
    return $return;
}

/**
 * Fungsi yang berguna untuk mendapatkan data tertentu dari model tertentu
 *
 * @param  string $model
 * @param  string $func
 * @param  array  $args
 * @param  string $field_name
 * @return array|string
 */
function get_row_data($model, $func, $args = array(), $field_name = '')
{
    $CI =& get_instance();
    $CI->load->model($model);

    $retrieve = call_user_func_array(array($CI->$model, $func), $args);

    if (empty($field_name)) {
        return $retrieve;
    } else {
        return isset($retrieve[$field_name]) ? $retrieve[$field_name] : '';
    }
}

/**
 * Method untuk mendapatkan data site config
 *
 * @param  string $id
 * @param  string $get   nama atau value
 * @return string data
 */
function get_pengaturan($id, $get = null)
{
    $result = get_row_data('config_model', 'retrieve', array($id), $get);
    return $result;
}

/**
 * Method untuk mendapatkan link base url ke template yang sedang aktif
 *
 * @param  string $add_link string tambahan untuk link
 * @return string link template
 */
function base_url_theme($add_link = '')
{
    $active_theme = get_active_theme();
    return base_url('assets/themes/'.$active_theme.'/'.$add_link);
}

/**
 * Method untuk mendapatkan link logo elearning
 *
 * @param  string $size pilihan small|medium|large
 * @return string link image
 */
function get_logo_url($size = 'small') {
    return base_url('assets/images/logo-'.strtolower($size).'.png');
}

/**
 * Method untuk mendapatkan nama template yang aktif
 *
 * @return string nama template
 */
function get_active_theme()
{
    return 'default';
}

/**
 * Method untuk mendapatkan css alert
 *
 * @param  string $notif
 * @param  string $msg
 * @return string
 */
function get_alert($notif = 'success', $msg = '')
{
    return '<div class="alert alert-'.$notif.'"><button type="button" class="close" data-dismiss="alert">×</button> '.$msg.'</div>';
}

/**
 * Method untuk panggil component tinymc
 *
 * @param  string $element_id
 * @return string
 */
function get_tinymce($element_id, $theme = 'advanced', $remove_plugins = array(), $str_options = null)
{
    $tiny_plugins = array('emotions','syntaxhl','wordcount','pagebreak','layer','table','save','advhr','advimage','advlink','insertdatetime','preview','searchreplace','contextmenu','paste','directionality','fullscreen','noneditable','visualchars','nonbreaking','xhtmlxtras','template','inlinepopups','autosave','print','media','youtubeIframe','syntaxhl','tiny_mce_wiris');
    if (!empty($remove_plugins)) {
        $copy_tiny_plugins = $tiny_plugins;
        $combine           = array_combine($tiny_plugins, $copy_tiny_plugins);
        foreach ($remove_plugins as $rm) {
            unset($combine[$rm]);
        }
        $tiny_plugins = array_values($combine);
    }

    $return = '<script type="text/javascript" src="'.base_url('assets/comp/tinymce/tiny_mce.js').'"></script>'.PHP_EOL;
    $return .= '<script type="text/javascript">
        tinyMCE.init({
            selector: "textarea#'.$element_id.'",
            theme : "'.$theme.'",
            plugins : "'.implode(',', $tiny_plugins).'",';

            if (empty($str_options)) {
                $return .= 'theme_advanced_buttons1 : "undo,redo,bold,italic,underline,strikethrough,bullist,numlist,justifyleft,justifycenter,justifyright,justifyfull,blockquote,link,unlink,sub,sup,charmap,tiny_mce_wiris_formulaEditor,emotions,image,media,youtubeIframe,syntaxhl,code",
                    theme_advanced_buttons2 : "",
                    theme_advanced_buttons3 : "",
                    theme_advanced_toolbar_location : "top",
                    theme_advanced_toolbar_align : "left",
                    theme_advanced_statusbar_location : "bottom",
                    file_browser_callback : "openKCFinder",
                    theme_advanced_resizing : true,
                    theme_advanced_resize_horizontal : false,
                    content_css : "'.base_url('assets/comp/tinymce/com/content.css').'",
                    convert_urls: false,
                    force_br_newlines : false,
                    force_p_newlines : false';
            } else {
                $return .= $str_options;
            }
    $return .= '});';

    $return .= 'function openKCFinder(field_name, url, type, win) {
            tinyMCE.activeEditor.windowManager.open({
                file: "'.base_url('assets/comp/kcfinder/browse.php?opener=tinymce&type=').'" + type,
                title: "KCFinder",
                width: 700,
                height: 500,
                resizable: "yes",
                inline: true,
                close_previous: "no",
                popup_css: false
            }, {
                window: win,
                input: field_name
            });
            return false;
        }
    </script>';
    return $return;
}

/**
 * Method untuk ngecek apakah sudah login atau belum
 *
 * @return boolean
 */
function is_login()
{
    $CI =& get_instance();

    $sess_data = $CI->session->userdata('login_' . APP_PREFIX);
    if (!empty($sess_data)) {
        return true;
    }

    return false;
}

/**
 * Fungsi yang bertugas redirect jika belum login
 */
function must_login()
{
    if (!is_login()) {
        redirect('login');
        die;
    }
}

/**
 * Method untuk ngecek apakah yang login itu admin atau bukan
 * @return boolean
 */
function is_admin()
{
    if (!is_login()) {
        return false;
    }

    $CI =& get_instance();

    $sess = $CI->session->userdata('login_' . APP_PREFIX);
    if (!empty($sess['admin'])) {
        return true;
    }

    return false;
}

/**
 * Method untuk ngecek apakah yang login itu pengajar atau bukan
 * @return boolean
 */
function is_pengajar()
{
    if (!is_login()) {
        return false;
    }

    $CI =& get_instance();

    $sess = $CI->session->userdata('login_' . APP_PREFIX);
    if (!empty($sess['pengajar'])) {
        return true;
    }

    return false;
}

/**
 * Method untuk ngecek apakah yang login itu siswa atau bukan
 * @return boolean
 */
function is_siswa()
{
    if (!is_login()) {
        return false;
    }

    $CI =& get_instance();

    $sess = $CI->session->userdata('login_' . APP_PREFIX);
    if (!empty($sess['siswa'])) {
        return true;
    }

    return false;
}

/**
 * Method untuk mendapatkan data session
 *
 * @param  string $key1
 * @param  string $key2
 * @return array
 */
function get_sess_data($key1, $key2)
{
    $CI =& get_instance();

    $sess_data = $CI->session->userdata('login_' . APP_PREFIX);
    if (!empty($sess_data)) {
        $type = '';
        if (is_admin()) {
            $type = 'admin';
        }
        if (is_pengajar()) {
            $type = 'pengajar';
        }
        if (is_siswa()) {
            $type = 'siswa';
        }

        if (!empty($type)) {
            return $sess_data[$type][$key1][$key2];
        }
    }
}

/**
 * Method untuk ngecek yang request ajax bukan
 *
 * @return boolean
 */
function is_ajax()
{
    /* AJAX check  */
    if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
        return true;
    }
    return false;
}

/**
 * Method untuk mendapatkan link gambar
 *
 * @param  string $img
 * @param  string $size
 * @return string
 *
 */
function get_url_image($img, $size = '')
{
    if (empty($size)) {
        return base_url('userfiles/images/'.$img);
    } else {
        $pisah     = explode('.', $img);
        $ext       = end($pisah);
        $nama_file = $pisah[0];

        return base_url('userfiles/images/'.$nama_file.'_'.$size.'.'.$ext);
    }
}

/**
 * Method untuk mendapatkan link foto siswa
 *
 * @param  string $img
 * @param  string $size
 * @param  string $jk
 * @return string url
 */
function get_url_image_siswa($img = '', $size = 'medium', $jk = 'Laki-laki') {
    if (is_null($img) OR empty($img)) {
        if ($jk == 'Laki-laki') {
            $img = 'default_siswa.png';
        } else {
            $img = 'default_siswi.png';
        }
        return get_url_image($img);
    } else {
        return get_url_image($img, $size);
    }
}

/**
 * Method untuk mendapatkan link foto pengajar
 *
 * @param  string $img
 * @param  string $size
 * @param  string $jk
 * @return string url
 */
function get_url_image_pengajar($img = '', $size = 'medium', $jk = 'Laki-laki') {
    if (is_null($img) OR empty($img)) {
        if ($jk == 'Laki-laki') {
            $img = 'default_pl.png';
        } else {
            $img = 'default_pp.png';
        }
        return get_url_image($img);
    } else {
        return get_url_image($img, $size);
    }
}

/**
 * Method untuk mendapatkan link foto pengajar/admin/siswa ketika sudah login
 *
 * @param  string $img
 * @param  string $size
 * @param  string $jk
 * @return string url
 */
function get_url_image_session($img = '', $size = 'medium', $jk = 'Laki-laki') {
    if (is_pengajar() OR is_admin()) {
        return get_url_image_pengajar($img, $size, $jk);
    } elseif (is_siswa()) {
        return get_url_image_siswa($img, $size, $jk);
    }
}

/**
 * Method untuk mendapatkan path image
 *
 * @param  string $img
 * @param  string $size medium|small, kalau aslinya di kosongkan
 * @return string paht
 */
function get_path_image($img = '', $size = '')
{
    if (empty($size)) {
        return './userfiles/images/'.$img;
    } else {
        $pisah = explode('.', $img);
        $ext = end($pisah);
        $nama_file = $pisah[0];

        return './userfiles/images/'.$nama_file.'_'.$size.'.'.$ext;
    }
}

/**
 * Deklarasi path file
 *
 * @param  string $file
 * @return string
 */
function get_path_file($file = '')
{
    return './userfiles/files/'.$file;
}


/**
 * Method untuk mendapatkan flashdata
 *
 * @param  string $key
 * @return string
 */
function get_flashdata($key)
{
    $CI =& get_instance();

    return $CI->session->flashdata($key);
}

/**
 * Fungsi untuk mendapatkan bulan dengan nama indonesia
 *
 * @param  string $bln
 * @return string
 */
function get_indo_bulan($bln = '')
{
    $data = array(1 => 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember');
    if (empty($bln)) {
        return $data;
    } else {
        $bln = (int)$bln;
        return $data[$bln];
    }
}

/**
 * Fungsi untuk mendapatkan nama hari indonesia
 *
 * @param  string $hari
 * @return string
 */
function get_indo_hari($hari = '')
{
    $data = array(1 => 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at', 'Sabtu', 'Minggu');
    if (empty($hari)) {
        return $data;
    } else {
        $hari = (int)$hari;
        return $data[$hari];
    }
}

/**
 * Method untuk memformat tanggal ke indonesia
 *
 * @param  string $tgl
 * @return string
 */
function tgl_indo($tgl = '')
{
    if (!empty($tgl)) {
        $pisah = explode('-', $tgl);
        return $pisah[2].' '.get_indo_bulan($pisah[1]).' '.$pisah[0];
    }
}

/**
 * Method untuk memformat tanggal dan jam ke format indonesia
 *
 * @param  string $tgl_jam
 * @return string
 */
function tgl_jam_indo($tgl_jam = '')
{
    if (!empty($tgl_jam)) {
        $pisah = explode(' ', $tgl_jam);
        return tgl_indo($pisah[0]).' '.date('H:i', strtotime($tgl_jam));
    }
}

/**
 * Metho untuk mendapatkan array post
 *
 * @param  string $key
 * @return string
 */
function get_post_data($key = '')
{
    if (isset($_POST[$key])) {
        return $_POST[$key];
    }

    return;
}

/**
 * Method untuk mendapatkan huruf berdasarkan nomornya
 *
 * @param  integer $index
 * @return string
 */
function get_abjad($index)
{
    $abjad = array(1 => 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');
    return $abjad[$index];
}

/**
 * Method untuk enkripsi url
 *
 * @param  string $current_url
 * @return string
 */
function enurl_redirect($current_url)
{
    return str_replace(array("%2F","%5C"), array("%252F","%255C"), urlencode($current_url));
}

/**
 * Method untuk deskripsi url
 *
 * @param  string $url
 * @return string
 */
function deurl_redirect($url)
{
    return urldecode(urldecode($url));
}

function pr($array) {
    echo '<pre>';
    print_r($array);
    echo '</pre>';
}

function get_data_array($array, $index1, $index2) {
    return $array[$index1][$index2];
}

/**
 * Fungsi untuk mendapatkan nama panggilan
 *
 * @param  string $str_nama
 * @return string
 */
function nama_panggilan($str_nama) {
    $split = explode(" ", $str_nama);
    return $split[0];
}

/**
 * Method untuk mengaktifkan natif session
 * http://stackoverflow.com/questions/6249707/check-if-php-session-has-already-started
 */
function start_native_session()
{
    if (session_id() == '') {
        session_start();
    }
}

/**
 * Method untuk membuat session kcfinder, karena kcfinder masih menggunakan natif session
 *
 * @param  integer $login_id
 */
function create_sess_kcfinder($login_id)
{
    if (is_login()) {
        # start natif session
        start_native_session();

        $_SESSION['E-LEARNING']['KCFINDER']              = array();
        $_SESSION['E-LEARNING']['KCFINDER']['disabled']  = false;
        $_SESSION['E-LEARNING']['KCFINDER']['uploadDir'] = "";
        if (is_admin()) {
            $_SESSION['E-LEARNING']['KCFINDER']['uploadURL'] = base_url('userfiles/uploads/');
        } else {
            $user_folder = './userfiles/uploads/' . $login_id;
            if (!is_dir($user_folder)) {
                mkdir($user_folder, 0755);
                chmod($user_folder, 0755);
            }
            $_SESSION['E-LEARNING']['KCFINDER']['uploadURL'] = base_url('userfiles/uploads/' . $login_id);
        }
    }
}

/**
 * Method untuk mendapatkan satu record tambahan
 *
 * @param  string $id
 * @return array
 */
function retrieve_field($id)
{
    return get_row_data('config_model', 'retrieve_field', array('id' => $id));
}

/**
 * Method untuk update field tambahan
 *
 * @param  string $id
 * @param  string $nama
 * @param  string $value
 * @return boolean
 */
function update_field($id, $nama = null, $value = null)
{
    return get_row_data('config_model', 'update_field', array($id, $nama, $value));
}

/**
 * Method untuk menghapus field tambahan berdasarkan id
 *
 * @param  string $id
 * @return boolean
 */
function delete_field($id)
{
    return get_row_data('config_model', 'delete_field', array('id' => $id));
}

/**
 * Method untuk membuat field tambahan
 *
 * @param  string $id
 * @param  string $nama
 * @param  string $value
 * @return boolean
 */
function create_field($id, $nama = null, $value = null)
{
    return get_row_data('config_model', 'create_field', array('id' => $id, 'nama' => $nama, 'value' => $value));
}

/**
 * Method untuk ngecek apakah pilihan ganda pertanyaan terpilih atau tidak
 *
 * @param  array    $array
 * @param  integer  $pertanyaan_id
 * @param  integer  $pilihan_id
 * @return boolean
 */
function is_pilih($array, $pertanyaan_id, $pilihan_id)
{
    if (isset($array[$pertanyaan_id]) AND $array[$pertanyaan_id] == $pilihan_id) {
        return true;
    }
    return false;
}

/**
 * Method untuk mendapatkan jawaban siswa berdasarkan pertanyaan_id
 *
 * @param  array   $array
 * @param  integer $pertanyaan_id
 * @return string
 */
function get_jawaban($array, $pertanyaan_id)
{
    if (!empty($array[$pertanyaan_id])) {
        return $array[$pertanyaan_id];
    }
}

/**
 * Method untuk mendapatkan kunci pada pilihan
 *
 * @param  array $pilihan
 * @return integer id pilihan
 */
function get_kunci_pilihan($pilihan)
{
    foreach ($pilihan as $value) {
        if ($value['kunci'] == 1) {
            return $value['id'];
        }
    }
}

/**
 * Method untuk mendapatkan ip pengakses
 * @return string
 */
function get_ip()
{
    return $_SERVER['REMOTE_ADDR'];
}

/**
 * Method untuk ngecek apakah siswa sudah mengerjakan tugas tertentu
 *
 * @param  integer $tugas_id
 * @param  integer $siswa_id
 * @return boolean
 */
function sudah_ngerjakan($tugas_id, $siswa_id)
{
    $sudah = false;

    # cek history, kalo sudah ada berarti sudah mengerjakan
    $check_history = retrieve_field('history-mengerjakan-' . $siswa_id . '-' . $tugas_id);
    if (!empty($check_history)) {
        # hapus field mengerjakan supaya lebih memastikan
        $mengerjakan_field_id = 'mengerjakan-' . $siswa_id . '-' . $tugas_id;
        delete_field($mengerjakan_field_id);

        $sudah = true;
    }

    return $sudah;
}

/**
 * Method untuk mendapatkan lama pengerjaan berdasarkan waktu mulai dan selesai
 *
 * @param  string $start
 * @param  string $finish
 * @return string
 */
function lama_pengerjaan($start, $finish)
{
    $date_a = new DateTime($start);
    $date_b = new DateTime($finish);

    $interval = date_diff($date_a, $date_b);

    $result  = $interval->format(" %h jam %i menit %s detik");
    $result  = str_replace(array(" 0 jam", " 0 menit", " 0 detik"), '', $result);

    return trim($result);
}

/**
 * Method untuk mendapatkan semua data email user yang berkedudukan sebagai admin
 *
 * @return array
 */
function get_email_admin()
{
    $results = array();

    $retrieve_all = get_row_data('login_model', 'retrieve_all', array(10, 1, 1, false));
    foreach ($retrieve_all as $login) {
        # cari pengajar
        $pengajar = get_row_data('pengajar_model', 'retrieve', array($login['pengajar_id']));
        if ($pengajar['status_id'] != 1) {
            continue;
        }

        $results[] = array(
            'nama'  => $pengajar['nama'],
            'email' => $login['username']
        );
    }

    return $results;
}

/**
 * Method untuk mengirimkan email
 *
 * @param  string $nama_email
 * @param  string $to
 * @param  array  $array_data
 * @return boolean
 */
function kirim_email($nama_email, $to, $array_data = array())
{
    # cari email
    $template = get_pengaturan($nama_email, 'value');
    $template = json_decode($template, 1);
    if (empty($template)) {
        return false;
    }

    $arr_old = array();
    $arr_new = array();
    foreach ((array)$array_data as $key => $value) {
        $arr_old[] = '{$'.$key.'}';
        $arr_new[] = $value;
    }

    $email_subject = str_replace($arr_old, $arr_new, $template['subject']);
    $email_body    = str_replace($arr_old, $arr_new, $template['body']);
    $email_server  = get_pengaturan('email-server', 'value');
    $nama_sekolah  = get_pengaturan('nama-sekolah', 'value');

    $CI =& get_instance();
    $CI->email->clear(true);

    $config['mailtype'] = 'html';
    # cek pakai smtp tidak
    $smtp_host = get_pengaturan('smtp-host', 'value');
    $smtp_user = get_pengaturan('smtp-username', 'value');
    $smtp_pass = get_pengaturan('smtp-pass', 'value');
    $smtp_port = get_pengaturan('smtp-port', 'value');
    if (!empty($smtp_host)) {
        $config['protocol']  = 'smtp';
        $config['smtp_host'] = $smtp_host;
        $config['smtp_user'] = $smtp_user;
        $config['smtp_pass'] = $smtp_pass;

        # cek port
        if (!empty($smtp_port)) {
            $config['smtp_port'] = $smtp_port;
        }
    }
    $CI->email->initialize($config);

    $CI->email->to($to);
    $CI->email->from($email_server, '[E-learning] - ' . $nama_sekolah);
    $CI->email->subject($email_subject);
    $CI->email->message($email_body);
    $CI->email->send();
    $CI->email->clear(true);

    return true;
}

/**
 * Method untuk mengirimkan email approve siswa
 *
 * @param  string $siswa_id
 */
function kirim_email_approve_siswa($siswa_id)
{
    $retrieve_siswa = get_row_data('siswa_model', 'retrieve', array($siswa_id));
    $login = get_row_data('login_model', 'retrieve', array(null, null, null, $siswa_id));

    $tabel_profil = '<table border="1" cellspacing="0" cellpadding="5">
        <tr>
            <td valign="top">NIS</td>
            <td>' . $retrieve_siswa['nis'] . '</td>
        </tr>
        <tr>
            <td valign="top">Nama</td>
            <td>' . $retrieve_siswa['nama'] . '</td>
        </tr>
        <tr>
            <td valign="top">Jenis kelamin</td>
            <td>' . $retrieve_siswa['jenis_kelamin'] . '</td>
        </tr>
        <tr>
            <td valign="top">Tempat lahir</td>
            <td>' . $retrieve_siswa['tempat_lahir'] . '</td>
        </tr>
        <tr>
            <td valign="top">Tgl. Lahir</td>
            <td>' . tgl_indo($retrieve_siswa['tgl_lahir']) . '</td>
        </tr>
        <tr>
            <td valign="top">Alamat</td>
            <td>' . $retrieve_siswa['alamat'] . '</td>
        </tr>
    </table>';

    @kirim_email('email-template-approve-siswa', $login['username'], array(
        'nama'         => $nama,
        'nama_sekolah' => get_pengaturan('nama-sekolah', 'value'),
        'tabel_profil' => $tabel_profil,
        'url_login'    => site_url('login')
    ));
}

/**
 * Method untuk mengirimkan email approve pengajar
 *
 * @param  integer $pengajar_id
 */
function kirim_email_approve_pengajar($pengajar_id)
{
    $pengajar = get_row_data('pengajar_model', 'retrieve', array($pengajar_id));
    $login    = get_row_data('login_model', 'retrieve', array(null, null, null, null, $pengajar_id));

    $tabel_profil = '<table border="1" cellspacing="0" cellpadding="5">
        <tr>
            <td valign="top">NIP</td>
            <td>' . $pengajar['nip'] . '</td>
        </tr>
        <tr>
            <td valign="top">Nama</td>
            <td>' . $pengajar['nama'] . '</td>
        </tr>
        <tr>
            <td valign="top">Jenis kelamin</td>
            <td>' . $pengajar['jenis_kelamin'] . '</td>
        </tr>
        <tr>
            <td valign="top">Tempat lahir</td>
            <td>' . $pengajar['tempat_lahir'] . '</td>
        </tr>
        <tr>
            <td valign="top">Tgl. Lahir</td>
            <td>' . tgl_indo($pengajar['tgl_lahir']) . '</td>
        </tr>
        <tr>
            <td valign="top">Alamat</td>
            <td>' . $pengajar['alamat'] . '</td>
        </tr>
    </table>';

    @kirim_email('email-template-approve-pengajar', $login['username'], array(
        'nama'         => $nama,
        'nama_sekolah' => get_pengaturan('nama-sekolah', 'value'),
        'tabel_profil' => $tabel_profil,
        'url_login'    => site_url('login')
    ));
}


/**
 * Method untuk mendapatkan email dari string
 *
 * @param  string $str
 * @return array
 */
function get_email_from_string($str)
{
    $pattern = '/[a-z\d._%+-]+@[a-z\d.-]+\.[a-z]{2,4}\b/i';

    preg_match_all($pattern, $str, $results);

    return $results[0];
}

/**
 * Method untuk ngecek sedang demo aplikasi atau tidak
 *
 * @return boolean
 */
function is_demo_app()
{
    $CI =& get_instance();
    $CI->load->config();
    return $CI->config->item('is_demo_app');
}

/**
 * Method untuk mendapatkan pesan jika sedang demo
 * @return string
 */
function get_demo_msg()
{
    return "Maaf, untuk keperluan demo aplikasi, halaman ini tidak dapat diperbaharui.";
}

/**
 * http://stackoverflow.com/questions/3475646/undefined-date-diff
 */
if (!function_exists('date_diff')) {
    function date_diff($date1, $date2)
    {
        $current = $date1;
        $datetime2 = date_create($date2);
        $count = 0;
        while(date_create($current) < $datetime2){
            $current = gmdate("Y-m-d", strtotime("+1 day", strtotime($current)));
            $count++;
        }
        return $count;
    }
}

/**
 * Method untuk mendapatkan data dari url
 *
 * @param  string $url
 * @return string body
 */
function get_url_data($url)
{
    # jika curl hidup
    if (function_exists('curl_version')) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_HEADER, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $response    = curl_exec($ch);
        $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        $header      = substr($response, 0, $header_size);
        $body        = substr($response, $header_size);
        $code        = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
    } else {
        $body = file_get_contents($url);
    }

    return $body;
}

/**
 * Method untuk cek apakah password siswa sama dengan nis
 *
 * @return boolean
 */
function pass_siswa_equal_nis()
{
    if (is_siswa()) {
        $nis_siswa = get_sess_data('user', 'nis');
        if (empty($nis_siswa)) {
            return false;
        }

        # ambil nis siswa
        $nis = get_row_data('siswa_model', 'retrieve', array(
            'id' => get_sess_data('user', 'id')
        ), 'nis');
        if (empty($nis)) {
            return false;
        }

        $md5_nis = md5($nis);

        # dapatkan password siswa
        $md5_pass = get_row_data('login_model', 'retrieve', array(
            'id' => get_sess_data('login', 'id')
        ), 'password');

        if ($md5_nis == $md5_pass) {
            return true;
        }
    }

    return false;
}