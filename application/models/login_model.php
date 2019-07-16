<?php

/**
 * Class Model untuk resource Login
 *
 * @package IndonesianSmartCode
 * @link    http://www.youtube.com/hisbil
 */
class Login_model extends CI_Model
{
    /**
     * Method untuk mendapatkan semua data user
     * @return array
     */
    public function retrieve_all_users()
    {
        $table_pengajar = $this->db->dbprefix('pengajar');
        $table_siswa    = $this->db->dbprefix('siswa');
        $table_login    = $this->db->dbprefix('login');

        $sql = "SELECT {$table_login}.username, {$table_pengajar}.nama FROM {$table_pengajar} INNER JOIN {$table_login} ON {$table_pengajar}.id = {$table_login}.pengajar_id
                UNION
                SELECT {$table_login}.username, {$table_siswa}.nama FROM {$table_siswa} INNER JOIN {$table_login} ON {$table_siswa}.id = {$table_login}.siswa_id";

        $result = $this->db->query($sql);

        $data = array();
        foreach ($result->result_array() as $r) {
            # selain yang login
            if (is_login() && $r['username'] == get_sess_data('login', 'username')) {
                continue;
            }
            $data[] = $r['nama'] . ' [' . $r['username'] . ']';
        }

        return $data;
    }

    /**
     * Method untuk menghapus data login
     *
     * @param  integer $id
     * @return boolean true jika berhasil
     * @author Hisbil Islami <hisbilislami92@gmail.com>
     */
    public function delete($id)
    {
        $id = (int)$id;

        $this->db->where('id', $id);
        $this->db->delete('login');
        return true;
    }

    /**
     * Method untuk mengambil banyak data login
     *
     * @param  integer $no_of_records
     * @param  integer $page_no
     * @param  integer $is_admin
     * @return array
     * @author Hisbil Islami <hisbilislami92@gmail.com>
     */
    public function retrieve_all(
        $no_of_records = 10,
        $page_no       = 1,
        $is_admin      = 0,
        $pagination    = true
    ) {
        $no_of_records = (int)$no_of_records;
        $page_no       = (int)$page_no;
        $is_admin      = (int)$is_admin;

        $where = array();
        if ($is_admin) {
            $where['is_admin'] = array($is_admin, 'where');
        }

        $orderby = array('id' => 'DESC');

        if ($pagination) {
            $data = $this->pager->set('login', $no_of_records, $page_no, $where, $orderby);
        } else {
            $no_of_records = $this->db->count_all('login');
            $search_all    = $this->pager->set('login', $no_of_records, $page_no, $where, $orderby);
            $data          = $search_all['results'];
        }

        return $data;
    }

    /**
     * Method untuk mengambil satu data login
     *
     * @param  null|integer $id
     * @param  null|string  $username
     * @param  null|string  $password
     * @param  null|integer $siswa_id
     * @param  null|integer $pengajar_id
     * @param  null|integer $is_admin
     * @return array
     * @author Hisbil Islami <hisbilislami92@gmail.com>
     */
    public function retrieve(
        $id          = null,
        $username    = null,
        $password    = null,
        $siswa_id    = null,
        $pengajar_id = null,
        $is_admin    = null,
        $reset_kode  = null
    ) {
        if (!is_null($id)) {
            $id = (int)$id;
            $this->db->where('id', $id);
        }
        if (!is_null($username)) {
            $this->db->where('username', $username);
        }
        if (!is_null($password)) {
            $this->db->where('password', $password);
        }
        if (!is_null($siswa_id)) {
            $siswa_id = (int)$siswa_id;
            $this->db->where('siswa_id', $siswa_id);
        }
        if (!is_null($pengajar_id)) {
            $pengajar_id = (int)$pengajar_id;
            $this->db->where('pengajar_id', $pengajar_id);
        }
        if (!is_null($is_admin)) {
            $is_admin = (int)$is_admin;
            $this->db->where('is_admin', $is_admin);
        }
        if (!is_null($reset_kode)) {
            $this->db->where('reset_kode', $reset_kode);
        }

        $result = $this->db->get('login', 1);
        return $result->row_array();
    }

    /**
     * Method untuk mengupdate password login
     *
     * @param  integer $id
     * @param  string  $password
     * @return boolean true jika berhasil
     * @author Hisbil Islami <hisbilislami92@gmail.com>
     */
    public function update_password($id, $password)
    {
        $id = (int)$id;

        $data = array('password' => md5($password));
        $this->db->where('id', $id);
        $this->db->update('login', $data);
        return true;
    }

    /**
     * Method untuk memperbaharui data login
     *
     * @param  integer      $id
     * @param  string       $username
     * @param  integer|null $siswa_id
     * @param  integer|null $pengajar_id
     * @param  integer      $is_admin
     * @param  string|null  $reset_kode
     * @return boolean      true jika berhasil
     * @author Hisbil Islami <hisbilislami92@gmail.com>
     */
    public function update(
        $id,
        $username,
        $siswa_id    = null,
        $pengajar_id = null,
        $is_admin    = 0,
        $reset_kode  = null
    ) {
        $id = (int)$id;
        if (!is_null($siswa_id)) {
            $siswa_id = (int)$siswa_id;
        }
        if (!is_null($pengajar_id)) {
            $pengajar_id = (int)$pengajar_id;
        }
        $is_admin = (int)$is_admin;

        # cek username
        $this->db->where('id !=', $id);
        $this->db->where('username', $username);
        $result = $this->db->get('login');
        $check  = $result->row_array();
        if (!empty($check)) {
            throw new Exception("Username sudah digunakan.");
        }

        $data = array(
            'username'    => $username,
            'siswa_id'    => $siswa_id,
            'pengajar_id' => $pengajar_id,
            'is_admin'    => $is_admin,
            'reset_kode'  => $reset_kode
        );
        $this->db->where('id', $id);
        $this->db->update('login', $data);
        return true;
    }

    /**
     * Method untuk menambah data login
     *
     * @param  string       $username
     * @param  string       $password
     * @param  integer|null $siswa_id
     * @param  integer|null $pengajar_id
     * @param  integer      $is_admin
     * @return integer      last insert id
     * @author Hisbil Islami <hisbilislami92@gmail.com>
     */
    public function create(
        $username,
        $password,
        $siswa_id    = null,
        $pengajar_id = null,
        $is_admin    = 0
    ) {
        if (!is_null($siswa_id)) {
            $siswa_id = (int)$siswa_id;
        }
        if (!is_null($pengajar_id)) {
            $pengajar_id = (int)$pengajar_id;
        }
        $is_admin = (int)$is_admin;

        $data = array(
            'username'    => $username,
            'password'    => md5($password),
            'siswa_id'    => $siswa_id,
            'pengajar_id' => $pengajar_id,
            'is_admin'    => $is_admin,
            'reset_kode'  => null
        );
        $this->db->insert('login', $data);
        return $this->db->insert_id();
    }
}
