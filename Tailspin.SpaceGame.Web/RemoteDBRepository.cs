using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Protocols;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Threading.Tasks;
using TailSpin.SpaceGame.Web;
using TailSpin.SpaceGame.Web.Models;

namespace Tailspin.SpaceGame.Web
{
    public class RemoteDBRepository : IDocumentDBRepository
    {
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public RemoteDBRepository(IConfiguration config)
        {
            configuration = config;
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public Task<Profile> GetProfileAsync(string profileId)
        {
            Profile user = new Profile();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = string.Format("SELECT * from dbo.Profiles where id = {0}", profileId);
                SqlCommand command = new SqlCommand(sql, conn);
                conn.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        foreach (PropertyInfo prop in user.GetType().GetProperties())
                        {
                            if (prop.Name != "Achievements")
                                prop.SetValue(user, Convert.ChangeType(reader[prop.Name], prop.PropertyType), null);
                        }
                    }
                }
                sql = string.Format("Select count(*) from dbo.Achievements a JOIN dbo.ProfileAchievements pa on a.id = pa.achievementid Where pa.profileid = {0}", profileId);
                command = new SqlCommand(sql, conn);
                int recordCount = (int)command.ExecuteScalar();
                sql = string.Format("Select a.description from dbo.Achievements a JOIN dbo.ProfileAchievements pa on a.id = pa.achievementid Where pa.profileid = {0}", profileId);
                command = new SqlCommand(sql, conn);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    //get the array of achievements
                    user.Achievements = new string[recordCount];
                    int i = 0;
                    while (reader.Read())
                    {
                        user.Achievements[i] = reader.GetString(0);
                        i++;
                    }
                }
                conn.Close();
            }
            return Task<Profile>.FromResult(user);
        }

        public Task<IEnumerable<Score>> GetScoresAsync(string mode, string region, int page = 1, int pageSize = 10)
        {
            List<Score> scores = new List<Score>();
            string sql = string.Format("Select * from dbo.scores order by score desc offset {0} rows fetch next {1} rows only", pageSize * (page - 1), pageSize);
            if (string.IsNullOrEmpty(mode) && !string.IsNullOrEmpty(region))
                sql = String.Format("Select * from dbo.scores where gameRegion = '{0}' order by score desc offset {1} rows fetch next {2} rows only ", region, pageSize * (page - 1), pageSize);
            if (!string.IsNullOrEmpty(mode) && string.IsNullOrEmpty(region))
                sql = String.Format("Select * from dbo.scores where gameMode = '{0}' order by score desc offset {1} rows fetch next {2} rows only ", mode, pageSize * (page - 1), pageSize);
            if (!string.IsNullOrEmpty(mode) && !string.IsNullOrEmpty(region))
                sql = String.Format("Select * from dbo.scores where gameMode = '{0}' and gameRegion = '{1}' order by score desc offset {2} rows fetch next {3} rows only ", mode, region, pageSize * (page - 1), pageSize);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(sql, conn);
                conn.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Score score = new Score();
                        foreach (PropertyInfo prop in score.GetType().GetProperties())
                        {
                            if (prop.Name == "HighScore")
                            {
                                prop.SetValue(score, Convert.ChangeType(reader["score"], prop.PropertyType), null);
                            }
                            else
                                prop.SetValue(score, Convert.ChangeType(reader[prop.Name], prop.PropertyType), null);
                        }
                        scores.Add(score);
                    }
                }
                conn.Close();
            }
            return Task<IEnumerable<Score>>.FromResult((IEnumerable<Score>)scores);
        }

        public Task<int> CountScoresAsync(string mode, string region)
        {
            int count;
            string sql = "";
            if (string.IsNullOrEmpty(mode) && string.IsNullOrEmpty(region))
                sql = "Select count(*) from scores";
            if (string.IsNullOrEmpty(mode) && !string.IsNullOrEmpty(region))
                sql = String.Format("Select count(*) from scores where gameRegion = '{0}'", region);
            if (!string.IsNullOrEmpty(mode) && string.IsNullOrEmpty(region))
                sql = String.Format("Select count(*) from scores where gameMode = '{0}'", mode);
            if (!string.IsNullOrEmpty(mode) && !string.IsNullOrEmpty(region))
                sql = String.Format("Select count(*) from scores where gameMode = '{0}' and gameRegion = '{1}'", mode, region);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(sql, conn);
                conn.Open();
                count = (int)command.ExecuteScalar();
                conn.Close();
            }
            return Task<int>.FromResult(count);
        }
    }
}
