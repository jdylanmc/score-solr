using System;
using System.Linq;
using Score.Data.Items.ContentSearch;
using Sitecore.ContentSearch;
using Sitecore.ContentSearch.ComputedFields;

namespace Score.Solr.ComputedFields
{
    public class FacetIds : IComputedIndexField
    {
        /// <summary>
        /// Computes the field value.
        /// </summary>
        /// <param name="indexable">The indexable.</param>
        /// <returns>System.Object.</returns>
        public object ComputeFieldValue(IIndexable indexable)
        {
            var item = (SitecoreIndexableItem)indexable;

            if (item == null)
                return null;

            if (item.Item.Fields.Contains(SearchablePageItem.FacetsFieldId))
            {
                SearchablePageItem searchable = item.Item;

                if (searchable == null)
                {
                    return null;
                }

                if (!string.IsNullOrEmpty(searchable.FacetsField.Value))
                {
                    return searchable.FacetsField.Value.Split('|').Select(x => Guid.Parse(x).ToString()).ToArray();
                }
            }

            return null;
        }

        /// <summary>
        /// Gets or sets the name of the field.
        /// </summary>
        /// <value>The name of the field.</value>
        public string FieldName { get; set; }

        /// <summary>
        /// Gets or sets the type of the return.
        /// </summary>
        /// <value>The type of the return.</value>
        public string ReturnType { get; set; }
    }
}
